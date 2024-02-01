# coding=utf8


from datetime import datetime

WriteableClass = {}


def traceDelete(tbl, pkVal):
    s = "|".join([tbl, str(pkVal)])
    print('traceDelete|' + s)
    return


def traceChange(tbl, pkVal, attrName, old, new):
    s = "|".join([tbl, str(pkVal), attrName, str(old), str(new)])
    print('traceChange|' + s)
    return


def traceNew(tbl, fields):
    s = '|'.join([tbl, str(fields)])
    print('traceNew|' + s)
    return


class HashIndexBase(object):
    __slots__ = ['values']

    def __init__(self, values):
        self.values = tuple(values)
        return

    def __hash__(self):
        return hash(self.values)

    def __eq__(self, other):
        if type(self) is type(other):
            return self.values == other.values
        return False

    def __str__(self):
        return '<%s %s>' % (self.__class__.__name__, self.values)


class HashIndex(object):
    __slots__ = [
        'cols',
        'name',
        'unique',
        'pk',
        'autoIncrement',
        'data',
        'fields',
        'colsIndex',
        'indexName',
    ]

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
        self.data = {}
        self.fields = None
        self.colsIndex = None
        self.indexName = self.name.title()  # indexMethod name

    def __str__(self):
        return '<%s %s>' % (self.__class__.__name__, self.cols)

    def __repr__(self):
        return self.__str__()

    def addObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            self.data[index] = obj
        else:
            if index in self.data:
                self.data[index].add(obj)
            else:
                self.data[index] = set()
                self.data[index].add(obj)
        return

    def removeObj(self, obj):
        index = self._getIndex(obj)
        if self.unique:
            del self.data[index]
        else:
            self.data[index].discard(obj)
        return

    def _getIndex(self, obj):
        values = [obj.fields[idx] for idx in self.colsIndex]
        index = HashIndexBase(values)
        return index

    def clear(self):
        self.data = {}
        return

    def get(self, **kwargs):
        assert len(kwargs) == len(self.cols)
        values = [kwargs[col] for col in self.cols]
        index = HashIndexBase(values)
        res = self.data.get(index)
        return res

    def __call__(self, **kwargs):
        # return self.get(**kwargs)
        raise NotImplemented


class Descriptor(object):
    __slots__ = [
        'name',
        'tbl',
        'fieldList',
        'indexList',
        'writeable',
        'ordered',
        'deletable',
        'primaryIndex',
        'fieldsName'
    ]

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
            index.colsIndex = tuple([i.idx for i in index.fields])
            if index.pk:
                if self.primaryIndex:
                    raise ValueError('Multiply primary key in %s.' % name)
                self.primaryIndex = index

        if not self.primaryIndex:
            for index in self.indexList:
                if index.unique:
                    self.primaryIndex = index
                    break

        if writeable:
            assert self.primaryIndex is not None, 'Writeable object must have an unique index.'

    def __str__(self):
        return '<%s %s>' % (self.__class__.__name__, self.name)

    def __repr__(self):
        return self.__str__()


class FieldDescriptor(object):
    __slots__ = ['name', 'kind', 'default', 'idx']

    def __init__(self, name, kind, default):
        self.name = name
        self.kind = kind
        self.default = default
        self.idx = None

    def __str__(self):
        return '<%s %s>' % (self.__class__.__name__, self.name)

    def __repr__(self):
        return self.__str__()


class DataMeta(type):
    def __new__(cls, name, bases, attrs):
        new_class = super().__new__(cls, name, bases, attrs)
        return new_class

    def __init__(cls, name, bases, attrs):
        cls.initAll()
        super().__init__(name, bases, attrs)

    def initAll(cls):
        # raise NotImplementedError("need initAll")
        pass


class DataBase(object):
    # common
    _incrementStep = 0
    _incrementSuffix = 0

    # private single table
    descriptor = None

    indexMap = None
    autoIndex = None
    autoIncrementValue = None
    size = None
    all = None
    dataClass = None
    isConfig = False

    sql_delete = None
    sql_update = None
    sql_select = None
    sql_create = None
    sql_insert = None

    record_delete_set = None
    record_update_set = None
    record_insert_set = None
    record_pk = None
    record_pk_delete = None

    def __init__(self):
        raise Exception(self.__class__.__name__, "cannot __init__")

    def __new__(cls, *args, **kwargs):
        raise Exception(cls.__name__, "cannot __new__")

    def __call__(self, *args, **kwargs):
        pass

    @classmethod
    def get(cls, indexName, **kwargs):
        if indexName not in cls.indexMap:
            raise ValueError(indexName, "not index allIndexName:", cls.indexMap.keys())
        return cls.indexMap[indexName].get(**kwargs)

    @classmethod
    def getIndexName(cls):
        return cls.indexMap.keys() if cls.indexMap else None

    @classmethod
    def getAll(cls):
        return cls.all

    @classmethod
    def new(cls, **kwargs):
        pass

    @classmethod
    def _new(cls, fields, _doTrace=True):
        if not fields:
            raise Exception(cls.__name__, "not fields")

        descriptor = cls.descriptor
        fields = list(fields)

        # check type
        for fd in descriptor.fieldList:
            val = fields[fd.idx]
            if not isinstance(val, type(fd.default)):
                raise TypeError(descriptor, fd, fd.default, val)

        # check idx
        if cls.autoIndex:
            if cls.autoIncrementValue <= 0:
                cls.autoIncrementValue = DataBase._incrementSuffix
            else:
                cls.fixAutoIncrementValue(cls.autoIncrementValue)
            name = cls.autoIndex.cols[0]
            aiFieldDescriptor = descriptor.fieldsName[name]
            colIdx = aiFieldDescriptor.idx
            step = DataBase._incrementStep
            idxVal = fields[colIdx]
            if not idxVal:
                cls.autoIncrementValue += step
                fields[colIdx] = cls.autoIncrementValue
            else:
                cls.fixAutoIncrementValue(idxVal)

        # new data
        obj = cls.dataClass(fields)
        for index in descriptor.indexList:
            index.addObj(obj)

        cls.all.add(obj)

        writeable = descriptor.writeable
        if writeable:
            cls.record_pk.add(obj.getPrimaryValue())
        if _doTrace and writeable:
            cls.record_insert_set.add(obj)
            cls.size += 1
            traceNew(cls.descriptor.tbl, fields)
        return obj

    @classmethod
    def setAutoIncrementSuffix(cls, suffix, suffixLength=4, radix=10):
        suffix = int(suffix)
        step = int(radix) ** int(suffixLength)
        assert 0 <= suffix < step, '`suffix` is out of range: [%d, %d)' % (0, step)
        cls._incrementStep = step
        cls._incrementSuffix = suffix
        return

    @classmethod
    def fixAutoIncrementValue(cls, value):
        if not value:
            return
        if value < cls.autoIncrementValue:
            return

        q, r = divmod(value, DataBase._incrementStep)
        if r == DataBase._incrementSuffix:
            cls.autoIncrementValue = value
        else:
            cls.autoIncrementValue = q * DataBase._incrementStep + DataBase._incrementSuffix
        return

    @classmethod
    def config(cls, conn):
        if cls.isConfig:
            return

        descriptor = cls.descriptor
        if not descriptor:
            raise TypeError("config not descriptor", descriptor)

        if cls.autoIndex:
            auto = conn.getAutoIncrement(descriptor.tbl)
            assert auto is not None, 'table %s: no auto_increment key' % descriptor.tbl
            cls.fixAutoIncrementValue(auto)

        sql = 'select count(*) from {};'.format(descriptor.tbl)
        count = conn.query(sql)[0][0]
        if not count:
            count = 0
        cls.size = count

        cls.isConfig = True
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
        _sql_select = cls.sql_select + (' where ' + condition if len(condition) != 0 else '')
        res = conn.query(_sql_select)
        for fields in res:
            cls._new(fields, _doTrace=False)
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
    def initSql(cls):
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

        cls.sql_create = 'create table if not exists `%s`(%s)' % (
            descriptor.tbl,
            ', '.join(['`%s` %s' % (i.name, i.kind) for i in fields]),
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
    def initIndexMethod(cls):
        descriptor = cls.descriptor
        for index in descriptor.indexList:
            if index.indexName in cls.indexMap:
                raise TypeError('Index name "%s" duplication.' % index.indexName)
            cls.indexMap[index.indexName] = index
        return

    @classmethod
    def readonly(cls):
        raise AttributeError('%s is none writeable.' % cls.__class__)

    @classmethod
    def initAll(cls):
        if not cls.descriptor:
            raise Exception("need descriptor", cls.__name__, cls.__class__)
        cls.initAttr()
        cls.initSql()
        cls.initIndexMethod()
        cls.initDataClass()
        return

    @classmethod
    def initAttr(cls):
        autoIndex = [i for i in cls.descriptor.indexList if i.autoIncrement]
        if len(autoIndex) > 1:
            raise TypeError('Multiple auto increment columns in "%s".' % cls.__name__)

        cls.indexMap = {}
        cls.autoIndex = autoIndex[0] if autoIndex else None
        cls.autoIncrementValue = 0
        cls.size = 0

        cls.all = set()
        cls.record_delete_set = set()
        cls.record_update_set = set()
        cls.record_insert_set = set()
        cls.record_pk = set()
        cls.record_pk_delete = set()
        return

    @classmethod
    def initDataClass(cls):
        descriptor = cls.descriptor

        class PropertyMeta(type):
            def __new__(cls, name, bases, attrs):
                new_class = super().__new__(cls, name, bases, attrs)
                return new_class

            def __init__(cls, name, bases, attrs):
                for field in descriptor.fieldList:
                    addProperty(cls, field, descriptor)
                super().__init__(name, bases, attrs)

        class Data(object, metaclass=PropertyMeta):
            __slots__ = ['cls', 'fields', 'fmt']

            def __init__(self, fields):
                self.cls = cls
                self.fields = fields
                self.fmt = '\n'.join(['  %s: %%s' % field.name for field in self.cls.descriptor.fieldList])

            def __str__(self):
                return '<%s %s %s>' % (self.__class__.__name__, self.cls.descriptor.tbl, self.fields[0])

            def __repr__(self):
                return self.__str__()

            def remove(self):
                writeable = self.cls.descriptor.writeable
                self.cls.all.discard(self)
                self.cls.record_delete_set.add(self)
                self.cls.record_pk.discard(self.getPrimaryValue())
                self.cls.record_pk_delete.add(self.getPrimaryValue())
                self.cls.size -= 1
                if writeable:
                    traceDelete(self.cls.descriptor.tbl, self.getPrimaryValue())
                del self
                return

            def toString(self):
                s = ('{\n' + (self.fmt % tuple(self.fields)) + '\n}\n')
                return s

            def setChanged(self):
                self.cls.record_update_set.add(self)
                return

            def getPrimaryValue(self):
                tupKey = tuple([self.fields[i] for i in self.cls.descriptor.primaryIndex.colsIndex])
                return tupKey

        cls.dataClass = Data
        return


def addProperty(cls, field, descriptor):
    writeable = descriptor.writeable
    idx = field.idx

    affectIndexList = [index for index in descriptor.indexList if field.name in index.cols]

    if not writeable:
        setter = cls.readonly()
    else:
        def setter(obj, value):
            if not isinstance(value, type(field.default)):
                raise TypeError(field, field.default, value)

            if obj.fields[idx] == value:
                return
            if field.name in descriptor.primaryIndex.cols:
                raise TypeError("Can't modify primary key")

            for index in affectIndexList:
                index.removeObj(obj)

            beforeVal = obj.fields[idx]
            obj.fields[idx] = value

            for index in affectIndexList:
                index.addObj(obj)

            obj.setChanged()
            traceChange(
                obj.cls.descriptor.tbl,
                obj.getPrimaryValue(),
                field.name,
                beforeVal,
                value,
            )
            return

    def getter(obj):
        return obj.fields[idx]

    setattr(cls, field.name, property(getter, setter))
    return


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
