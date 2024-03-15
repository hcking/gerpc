# coding=utf8

from collections import OrderedDict
from persist import writeback
from persist.fn import escape, getPrimaryValue, getIndex
from data.excel2csv import loadCsvData


class Increment:
    _isConfig = False
    _incrementStep = 0
    _incrementSuffix = 0

    def __new__(cls, *args, **kwargs):
        raise NotImplemented

    @classmethod
    def setAutoIncrementSuffix(cls, suffix, radix=10, suffixLength=5):
        suffix = int(suffix)
        step = int(radix) ** int(suffixLength)
        assert 0 < suffix < step, '`suffix` is out of range: [%d, %d)' % (1, step)
        cls._incrementStep = step
        cls._incrementSuffix = suffix
        cls._isConfig = True
        return

    @classmethod
    def getStep(cls):
        if not cls._isConfig:
            raise AttributeError("need setAutoIncrementSuffix")
        return cls._incrementStep

    @classmethod
    def getSuffix(cls):
        if not cls._isConfig:
            raise AttributeError("need setAutoIncrementSuffix")
        return cls._incrementSuffix


class HashIndexBase:
    __slots__ = ('values',)

    def __init__(self, values):
        self.values = tuple(values)
        return

    def __hash__(self):
        return hash(self.values)

    def __eq__(self, other):
        if isinstance(other, HashIndexBase):
            return self.values == other.values
        return False


class HashIndex:
    __slots__ = (
        'cols',
        'name',
        'unique',
        'pk',
        'autoIncrement',
        'fields',
        'indexName',
        'data',
    )

    def __str__(self):
        s = '<{} {} {}>'.format(self.__class__.__name__, self.name, self.cols)
        return s

    def __repr__(self):
        return self.__str__()

    def __init__(self, cols, name=None, unique=False, pk=False, auto=False):
        self.cols = cols
        self.name = (cols[0] + '_Idx') if name is None else name
        if auto and len(cols) != 1:
            raise TypeError('Auto increment index must be based on only one column.')
        self.unique = unique or auto
        self.pk = pk or auto
        if self.pk and not self.unique:
            raise TypeError('Primary key must be unique.')
        self.autoIncrement = auto
        self.fields = None
        self.indexName = self.name.title()  # indexMethod name
        self.data = {}

    def addObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            if index in self.data:
                raise IndexError("repeat index", self, self.data[index], obj)
            self.data[index] = obj
        else:
            if index in self.data:
                self.data[index].add(obj)
            else:
                self.data[index] = {obj}
        return

    def removeObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            if index not in self.data:
                print('removeObj unique index', index.values, obj)
            else:
                del self.data[index]
        else:
            self.data[index].discard(obj)
        return

    def _getIndex(self, obj):
        values = getIndex(obj.data, self.cols)
        index = HashIndexBase(values)
        return index

    def getObj(self, **kwargs):
        if len(kwargs) != len(self.cols):
            raise Exception("index error", self.cols)
        values = [kwargs[col] for col in self.cols]
        index = HashIndexBase(values)
        res = self.data.get(index)
        return res

    def clean(self):
        self.data = {}


class Descriptor:
    __slots__ = (
        'name',
        'tbl',
        'fieldList',
        'indexList',
        'writeable',
        'ordered',
        'deletable',
        'primaryIndex',
        'fieldsName',
        'affectIndexMap',
    )

    def __str__(self):
        return '<%s %s %s>' % (self.__class__.__name__, self.name, self.tbl)

    def __repr__(self):
        return self.__str__()

    def __init__(
            self,
            name,
            tbl,
            fieldList,
            indexList=None,
            writeable=False,
            ordered=False,
            deletable=False,
    ):
        self.name = name
        self.tbl = tbl
        self.fieldList = fieldList
        self.indexList = indexList
        self.writeable = writeable
        self.ordered = ordered
        self.deletable = deletable
        self.primaryIndex = None
        self.fieldsName = {}
        self.affectIndexMap = {}

        for idx, field in enumerate(self.fieldList):
            field.idx = idx
            self.fieldsName[field.name] = field
            affectIndex = [index for index in self.indexList if field.name in index.cols]
            self.affectIndexMap[field.name] = affectIndex

        for index in self.indexList:
            index.fields = tuple([self.fieldsName[i] for i in index.cols])
            if index.pk:
                if self.primaryIndex:
                    raise Exception('Multiply primary key in %s.' % name)
                self.primaryIndex = index

        if not self.primaryIndex:
            for index in self.indexList:
                if index.unique:
                    self.primaryIndex = index
                    break

        if writeable:
            assert self.primaryIndex is not None, 'writeable object must have an unique index.'


class FieldDescriptor:
    __slots__ = ('name', 'default', 'idx', 'colName', 'converter')

    def __str__(self):
        return '<%s %s %s>' % (self.__class__.__name__, self.name, self.colName)

    def __repr__(self):
        return self.__str__()

    def __init__(self, name, default, colName=None, converter=None):
        self.name = name
        self.default = default
        self.idx = None
        self.colName = colName
        self.converter = converter


class CattyMeta(type):
    def __new__(cls, name, bases, attrs):
        return super().__new__(cls, name, bases, attrs)

    def __init__(cls, name, bases, attrs):
        cls._initAllByDescriptor()
        super().__init__(name, bases, attrs)

    def _initAllByDescriptor(cls):
        raise NotImplementedError


class CattyBase:
    source = None
    descriptor = None

    _indexMap = None
    _autoIndex = None
    _autoIncrementValue = None

    _all = None
    _all_pk = None
    _isConfig = False

    sql_delete = None
    sql_update = None
    sql_select = None
    sql_insert = None

    writeBack = None
    _isLoadAll = False

    def __new__(cls, *args, **kwargs):
        raise NotImplemented

    @classmethod
    def getByIndex(cls, indexName, **kwargs):
        if indexName not in cls._indexMap:
            raise AttributeError(indexName, "no index allIndexName:", cls._indexMap.keys())
        return cls._indexMap[indexName].getObj(**kwargs)

    @classmethod
    def getIndexNames(cls):
        return cls._indexMap.keys() if cls._indexMap else None

    @classmethod
    def all(cls):
        return cls._all

    @classmethod
    def new(cls, **kwargs):
        """ user add data """
        if cls._autoIndex:
            if kwargs.get(cls._autoIndex.cols[0], None) != 0:
                raise AttributeError(cls._autoIndex, 'auto must be 0')
            if not cls._isLoadAll:
                raise AttributeError(cls, cls._autoIndex, 'autoIndex must be load or limit_load_all')

        for index in cls.descriptor.indexList:
            if index.unique:
                for attr in index.cols:
                    if attr not in kwargs:
                        raise AttributeError('unique index must index, not default', cls, index, attr)
        data = cls._genDataByDict(kwargs)
        return cls._newData(data, _doTrace=True)

    @classmethod
    def clean(cls, force=False):
        """
        !!! remove all
        !!! too dangerous
        """
        if force is not True:
            raise AttributeError('!!! too dangerous')

        if not cls.descriptor.writeable:
            raise AttributeError('can not clean', cls)

        _all = cls.all()
        if not _all:
            return
        for item in list(_all):
            item.remove()
        return

    @classmethod
    def _genDataByList(cls, fields):
        data = OrderedDict()

        for field in cls.descriptor.fieldList:
            val = fields[field.idx]
            data[field.name] = val
        return data

    @classmethod
    def _genDataByDict(cls, kwargs):
        data = OrderedDict()
        for field in cls.descriptor.fieldList:
            if field.name not in kwargs:
                kwargs[field.name] = field.default
            val = kwargs[field.name]
            data[field.name] = val
        return data

    @classmethod
    def i_checkType(cls, val, field, data=None):
        if not isinstance(val, type(field.default)):
            raise TypeError(cls.descriptor, field, field.default, val, data)
        return

    @classmethod
    def _checkIdx(cls, data):
        if not cls._autoIndex:
            return

        col = cls._autoIndex.cols[0]
        if data[col]:
            cls._fixAutoIncrementValue(data[col])
        else:
            step = Increment.getStep()
            cls._autoIncrementValue += step
            data[col] = cls._autoIncrementValue
        return

    @classmethod
    def _newData(cls, data, _doTrace):
        cls._checkIdx(data)

        for field in cls.descriptor.fieldList:
            val = data[field.name]
            cls.i_checkType(val, field, data)

        obj = Data(cls, data)

        if cls.writeBack:
            pk = getPrimaryValue(data, cls.descriptor)
            if pk in cls._all_pk or pk in cls.writeBack.record_pk_delete:
                return

        for index in cls.descriptor.indexList:
            index.addObj(obj)

        cls._all.add(obj)
        pkVal = getPrimaryValue(obj.data, cls.descriptor)
        cls._all_pk.add(pkVal)

        writeback.newObj(cls, obj, _doTrace=_doTrace)
        return obj

    @classmethod
    def _fixAutoIncrementValue(cls, value):
        if value <= 0:
            return

        if value < cls._autoIncrementValue:
            return

        q, r = divmod(value, Increment.getStep())
        if r == Increment.getSuffix():
            cls._autoIncrementValue = value
        else:
            cls._autoIncrementValue = q * Increment.getStep() + Increment.getSuffix()
        return

    @classmethod
    def config(cls, conn):
        if cls._isConfig:
            return

        descriptor = cls.descriptor
        if not descriptor:
            raise Exception("config not descriptor", descriptor)

        if cls._autoIndex:
            auto = conn.getAutoIncrement(descriptor.tbl)
            assert auto is not None, 'table %s: no auto_increment key' % descriptor.tbl
            cls._fixAutoIncrementValue(auto)
            if cls._autoIncrementValue <= 0:
                cls._autoIncrementValue = Increment.getSuffix()

        cls._isConfig = True
        return

    @classmethod
    def load(cls, conn, **kwargs):
        cls.config(conn)

        kw = kwargs
        if not kw:
            cls._isLoadAll = True

        kvs = [(k, v) for k, v in kw.items() if not isinstance(v, set)]
        values = ['`%s`=%s' % (k, escape(v)) for k, v in kvs]
        kvs = [(k, v) for k, v in kw.items() if isinstance(v, set)]
        sets = ['`%s` in (%s)' % (k, ','.join([escape(v) for v in s]) or 'null') for k, s in kvs]
        condition = ' and '.join(values + sets)
        _sql_select = cls.sql_select + (' where ' + condition if len(condition) != 0 else '')
        res = conn.query(_sql_select)
        for fields in res:
            data = cls._genDataByList(fields)
            cls._newData(data, _doTrace=False)
        return

    @classmethod
    def loadcsv(cls):
        if cls.descriptor.writeable:
            raise AttributeError("must be excel table")

        res = loadCsvData(cls)
        for fields in res:
            data = cls._genDataByList(fields)
            cls._newData(data, _doTrace=False)
        return

    @classmethod
    def reload(cls):
        if cls.descriptor.writeable:
            raise AttributeError("must be excel table")

        cls._all = set()
        cls._all_pk = set()

        for index in cls.descriptor.indexList:
            index.clean()

        cls.loadcsv()
        return

    @classmethod
    def _limit_load(cls, conn, begin, end):
        cls.config(conn)

        if end > 0:
            _sql_select = '{} limit {},{}'.format(cls.sql_select, begin, end)
        else:
            _sql_select = cls.sql_select

        res = conn.query(_sql_select)
        for fields in res:
            data = cls._genDataByList(fields)
            cls._newData(data, _doTrace=False)
        return len(res)

    @classmethod
    def limit_load_all(cls, conn, limit=0):
        from data.loadcfg import getLoadLimit
        cls.config(conn)
        begin = 0
        if limit > 0:
            end = limit
        else:
            end = getLoadLimit(cls)
        while True:
            count = cls._limit_load(conn, begin, end)
            if count != end:
                break
            begin += end
        cls._isLoadAll = True
        return

    @classmethod
    def _initSql(cls):
        descriptor = cls.descriptor
        fields = descriptor.fieldList
        cols = ', '.join(['`%s`' % i.name for i in fields])
        cls.sql_insert = 'insert into `%s`(%s) values(%s)' % (
            descriptor.tbl,
            cols,
            ', '.join(['%s'] * len(fields)),
        )

        cls.sql_select = 'select %s from `%s`' % (
            cols,
            descriptor.tbl,
        )

        if descriptor.primaryIndex:
            pk = descriptor.primaryIndex
            pkCondition = ' and '.join(['`%s`=%%s' % col for col in pk.cols])
            cls.sql_update = 'update `%s` set %s where %s' % (
                descriptor.tbl,
                ', '.join(['`%s`=%%s' % i.name for i in fields]),
                pkCondition,
            )
            cls.sql_delete = 'delete from `%s` where %s' % (
                descriptor.tbl,
                pkCondition,
            )
        return

    @classmethod
    def _initAllByDescriptor(cls):
        if not cls.descriptor:
            raise Exception("need descriptor", cls.__name__, cls.__class__)
        cls._initAttr()
        cls._initSql()
        cls._initIndexMethod()
        return

    @classmethod
    def _initIndexMethod(cls):
        descriptor = cls.descriptor
        for index in descriptor.indexList:
            if index.indexName in cls._indexMap:
                raise Exception('Index name "%s" duplication.' % index.indexName)
            cls._indexMap[index.indexName] = index
        return

    @classmethod
    def _initAttr(cls):
        autoIndex = [i for i in cls.descriptor.indexList if i.autoIncrement]
        if len(autoIndex) > 1:
            raise Exception('Multiple auto increment columns in "%s".' % cls.__name__)

        cls._indexMap = {}
        cls._all = set()
        cls._all_pk = set()

        cls._autoIndex = autoIndex[0] if autoIndex else None
        cls._autoIncrementValue = 0

        cls.writeBack = writeback.newWriteBack(cls)
        cls._isLoadAll = False
        return


class Data:
    __slots__ = ('cls', 'data')

    def __init__(self, cls, data):
        self.cls = cls
        self.data = data

    def __str__(self):
        return '<%s %s %s>' % (self.__class__.__name__, self.cls.descriptor.tbl, str(self.data))

    def __repr__(self):
        return self.__str__()

    def remove(self):
        if not self.cls.descriptor.writeable:
            raise AttributeError('cant remove', self.cls, self)

        writeback.removeObj(self.cls, self)
        return

    def get(self, attr):
        if attr not in self.data:
            raise AttributeError(self, "get error", attr)
        return self.data[attr]

    def set(self, attr, value):
        if not self.cls.descriptor.writeable:
            raise AttributeError('%s is none writeable.' % self.cls.__class__)

        if attr in self.cls.descriptor.primaryIndex.cols:
            raise AttributeError("Can't modify primary key")

        beforeVal = self.get(attr)
        if beforeVal == value:
            return

        # check type
        field = self.cls.descriptor.fieldsName[attr]
        self.cls.i_checkType(value, field)

        affectIndex = self.cls.descriptor.affectIndexMap[attr]
        for index in affectIndex:
            index.removeObj(self)

        self.data[attr] = value

        for index in affectIndex:
            index.addObj(self)

        writeback.changeObj(
            cls=self.cls,
            obj=self,
            beforeVal=beforeVal,
            value=value,
            attr=attr,
        )
        return
