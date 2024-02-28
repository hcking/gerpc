# coding=utf8

from collections import OrderedDict
from datetime import datetime
from persist.trace import Trace


class Increment:
    _isConfig = False
    _incrementStep = 0
    _incrementSuffix = 0

    def __new__(cls, *args, **kwargs):
        raise NotImplementedError

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
        if type(self) is type(other):
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
        '_data',
    )

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
        self._data = {}

    def addObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            self._data[index] = obj
        else:
            if index in self._data:
                self._data[index].add(obj)
            else:
                self._data[index] = set()
                self._data[index].add(obj)
        return

    def removeObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            del self._data[index]
        else:
            self._data[index].discard(obj)
        return

    def _getIndex(self, obj):
        values = obj.i_getIndex(self.cols)
        index = HashIndexBase(values)
        return index

    def getObj(self, **kwargs):
        if len(kwargs) != len(self.cols):
            raise Exception("index error", self.cols)
        values = [kwargs[col] for col in self.cols]
        index = HashIndexBase(values)
        res = self._data.get(index)
        return res


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
        'fieldsName'
    )

    def __init__(self, name, tbl, fieldList, indexList=None, writeable=False, ordered=False, deletable=False):
        assert isinstance(fieldList, list)
        self.name = name
        self.tbl = tbl
        self.fieldList = fieldList
        self.indexList = indexList
        self.writeable = writeable
        self.ordered = ordered
        self.deletable = deletable
        self.primaryIndex = None
        self.fieldsName = {}

        for idx, field in enumerate(self.fieldList):
            field.idx = idx
            self.fieldsName[field.name] = field

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
            assert self.primaryIndex is not None, 'Writeable object must have an unique index.'


class FieldDescriptor:
    __slots__ = ('name', 'kind', 'default', 'idx')

    def __init__(self, name, kind, default):
        self.name = name
        self.kind = kind
        self.default = default
        self.idx = None


class CattyMeta(type):
    def __new__(cls, name, bases, attrs):
        return super().__new__(cls, name, bases, attrs)

    def __init__(cls, name, bases, attrs):
        cls._initAllByDescriptor()
        super().__init__(name, bases, attrs)

    def _initAllByDescriptor(cls):
        raise NotImplementedError


class CattyBase:
    descriptor = None

    _indexMap = None
    _autoIndex = None
    _autoIncrementValue = None
    _size = None
    _all = None
    _isConfig = False

    _sql_delete = None
    _sql_update = None
    _sql_select = None
    _sql_create = None
    _sql_insert = None

    _record_delete = None
    _record_update = None
    _record_insert = None
    _record_pk = None
    _record_pk_delete = None

    def __new__(cls, *args, **kwargs):
        raise NotImplementedError

    @classmethod
    def getByIndex(cls, indexName, **kwargs):
        if indexName not in cls._indexMap:
            raise AttributeError(indexName, "not index allIndexName:", cls._indexMap.keys())
        return cls._indexMap[indexName].getObj(**kwargs)

    @classmethod
    def getIndexNames(cls):
        return cls._indexMap.keys() if cls._indexMap else None

    @classmethod
    def all(cls):
        return cls._all

    @classmethod
    def new(cls, **kwargs):
        """ user add add data """
        if cls._autoIndex:
            if kwargs.get(cls._autoIndex.cols[0], 0) != 0:
                raise AttributeError(cls._autoIndex, 'auto must be 0 or no input')

        data = cls._genDataByDict(kwargs)
        return cls._newObj(data, _doTrace=True)

    @classmethod
    def _genDataByList(cls, fields):
        data = OrderedDict()
        # check type
        for field in cls.descriptor.fieldList:
            val = fields[field.idx]
            cls.i_checkType(val, field)

            data[field.name] = val
        return data

    @classmethod
    def _genDataByDict(cls, kwargs):
        data = OrderedDict()
        for field in cls.descriptor.fieldList:
            if field.name not in kwargs:
                kwargs[field.name] = field.default

            val = kwargs[field.name]
            cls.i_checkType(val, field)
            data[field.name] = val
        return data

    @classmethod
    def i_checkType(cls, val, field):
        if not isinstance(val, type(field.default)):
            raise TypeError(cls.descriptor, field, field.default, val)
        return

    @classmethod
    def _checkIdx(cls, data):
        if cls._autoIndex:
            col = cls._autoIndex.cols[0]
            if data[col]:
                cls._fixAutoIncrementValue(data[col])
            else:
                step = Increment.getStep()
                cls._autoIncrementValue += step
                data[col] = cls._autoIncrementValue
        return

    @classmethod
    def _newObj(cls, data, _doTrace=True):
        cls._checkIdx(data)
        # new data
        obj = Data(cls, data)
        for index in cls.descriptor.indexList:
            index.addObj(obj)

        cls._all.add(obj)

        writeable = cls.descriptor.writeable
        if writeable:
            cls._record_pk.add(obj.i_getPrimaryValue())
            if _doTrace:
                cls._record_insert.add(obj)
                cls._size += 1
                Trace.traceNew(cls.descriptor.tbl, list(data.values()))
        return obj

    @classmethod
    def i_removeObj(cls, obj):
        cls._all.discard(obj)
        cls._record_delete.add(obj)
        pkVal = obj.i_getPrimaryValue()
        cls._record_pk.discard(pkVal)
        cls._record_pk_delete.add(pkVal)
        cls._size -= 1
        writeable = cls.descriptor.writeable
        if writeable:
            Trace.traceDelete(
                tbl=cls.descriptor.tbl,
                pkVal=pkVal,
            )
        return

    @classmethod
    def i_changeObj(cls, obj, beforeVal, value, attr):
        cls._record_update.add(obj)
        Trace.traceChange(
            tbl=cls.descriptor.tbl,
            pkVal=obj.i_getPrimaryValue(),
            attrName=attr,
            old=beforeVal,
            new=value,
        )
        return

    @classmethod
    def _fixAutoIncrementValue(cls, value):
        if not value:
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

        sql = 'select count(*) from {};'.format(descriptor.tbl)
        count = conn.query(sql)[0][0]
        if not count:
            count = 0
        cls._size = count

        cls._isConfig = True
        return

    @classmethod
    def load(cls, conn, sql_condition='', **kwargs):
        cls.config(conn)

        kw = kwargs
        kvs = [(k, v) for k, v in kw.items() if not isinstance(v, set)]
        values = ['`%s`=%s' % (k, escape(v)) for k, v in kvs]
        kvs = [(k, v) for k, v in kw.items() if isinstance(v, set)]
        sets = ['`%s` in (%s)' % (k, ','.join([escape(v) for v in s]) or 'null') for k, s in kvs]
        _sql = [sql_condition] if sql_condition != '' else []
        condition = ' and '.join(values + sets + _sql)
        _sql_select = cls._sql_select + (' where ' + condition if len(condition) != 0 else '')
        res = conn.query(_sql_select)
        for fields in res:
            data = cls._genDataByList(fields)
            cls._newObj(data, _doTrace=False)
            # if descriptor.writeable:
            #     pk = primaryKey(cls, fields)
            #     if pk not in cls.record_pk and pk not in cls.record_pk_delete:
            # else:
            #     _r = list(fields)
            #     for i, v in enumerate(_r):
            #         dec = descriptor.fieldList[i].decode
            #         if dec is not None:
            #             _r[i] = dec(v)
            #     cls.new(_r, _doTrace=False)
        return

    @classmethod
    def _initSql(cls):
        descriptor = cls.descriptor
        fields = descriptor.fieldList
        cols = ', '.join(['`%s`' % i.name for i in fields])
        cls._sql_insert = 'insert into `%s`(%s) values(%s)' % (
            descriptor.tbl,
            cols,
            ', '.join(['%s'] * len(fields)),
        )

        cls._sql_select = 'select %s from `%s`' % (
            cols,
            descriptor.tbl,
        )

        cls._sql_create = 'create table if not exists `%s`(%s)' % (
            descriptor.tbl,
            ', '.join(['`%s` %s' % (i.name, i.kind) for i in fields]),
        )

        if descriptor.primaryIndex:
            pk = descriptor.primaryIndex
            pkCondition = ' and '.join(['`%s`=%%s' % col for col in pk.cols])
            cls._sql_update = 'update `%s` set %s where %s' % (
                descriptor.tbl,
                ', '.join(['`%s`=%%s' % i.name for i in fields]),
                pkCondition,
            )
            cls._sql_delete = 'delete from `%s` where %s' % (
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
        cls._autoIndex = autoIndex[0] if autoIndex else None
        cls._autoIncrementValue = 0
        cls._size = 0

        cls._all = set()
        cls._record_delete = set()
        cls._record_update = set()
        cls._record_insert = set()
        cls._record_pk = set()
        cls._record_pk_delete = set()
        return


class Data:
    __slots__ = ('_cls', '_data',)

    def __init__(self, cls, data):
        self._cls = cls
        self._data = data

    def __str__(self):
        return '<%s %s %s>' % (self.__class__.__name__, self._cls.descriptor.tbl, id(self))

    def __repr__(self):
        return self.__str__()

    def remove(self):
        self._cls.i_removeObj(self)
        return

    def get(self, attr):
        if attr not in self._data:
            raise AttributeError(self, "get error", attr)
        return self._data.get(attr)

    def set(self, attr, value):
        if not self._cls.descriptor.writeable:
            raise AttributeError('%s is none writeable.' % self._cls.__class__)

        if attr in self._cls.descriptor.primaryIndex.cols:
            raise AttributeError("Can't modify primary key")

        beforeVal = self.get(attr)
        if beforeVal == value:
            return

        # check type
        field = self._cls.descriptor.fieldsName.get(attr)
        self._cls.i_checkType(value, field)

        self._data[attr] = value
        self._cls.i_changeObj(
            obj=self,
            beforeVal=beforeVal,
            value=value,
            attr=attr,
        )
        return

    def i_getIndex(self, cols):
        return (self._data[name] for name in cols)

    def i_getPrimaryValue(self):
        return tuple(self._data[i] for i in self._cls.descriptor.primaryIndex.cols)


def escape(v):
    if v is None:
        return 'null'
    if type(v) is str:
        if "'" in v:
            return '"%s"' % v
        return "'%s'" % v
    if type(v) is datetime:
        return "'%s'" % v.strftime('%Y-%m-%d %H:%M:%S')
    return '%s' % v
