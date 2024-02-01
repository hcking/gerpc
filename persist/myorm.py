# coding=utf8


from datetime import datetime

WriteableClass = {}


def traceDelete(*args):
    print('traceDelete', args)
    return


def traceChange(*args):
    print('traceChange', args)
    return


def traceNew(*args):
    print('traceNew', args)
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
        'idxName',
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
        self.idxName = self.name.title()  # indexMethod name

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
        return self.get(**kwargs)


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
    descriptor = None
    all = set()
    allIdx = []
    dataClass = None
    isConfig = False
    subclassCount = 0

    # fix
    _incrementStep = 1
    _incrementSuffix = 0
    _autoIncrementValue = 0
    size = 0

    # sql
    sql_delete = ""
    sql_update = ""
    sql_select = ""
    sql_create = ""
    sql_insert = ""

    # record change
    record_delete_set = set()
    record_update_set = set()
    record_insert_set = set()
    record_pk = set()
    record_pk_delete = set()

    def __init__(self):
        raise Exception(self.__class__.__name__, "cannot __init__")

    def __new__(cls, *args, **kwargs):
        raise Exception(cls.__name__, "cannot __new__")

    @classmethod
    def new(cls, fields, _doTrace=True):
        if not fields:
            raise Exception(cls.__name__, "not fields")

        descriptor = cls.descriptor
        fields = list(fields)

        # check type
        for fd in descriptor.fieldList:
            val = fields[fd.idx]
            if type(fd.default) is not type(val):
                raise TypeError(descriptor, fd, fd.default, val)

        # check idx
        ais = [i for i in descriptor.indexList if i.autoIncrement]
        assert len(ais) <= 1, 'Multiple auto increment columns in "%s".' % cls.__name__
        if len(ais) == 1:
            if cls._autoIncrementValue <= 0:
                cls._autoIncrementValue = cls._incrementSuffix
            else:
                cls.fixAutoIncrementValue(cls._autoIncrementValue)
            name = ais[0].cols[0]
            aiFieldDescriptor = descriptor.fieldsName[name]
            colIdx = aiFieldDescriptor.idx
            DataBase.subclassCount += 1
            step = cls._incrementStep
            idxVal = fields[colIdx]
            if not idxVal:
                cls._autoIncrementValue += step
                fields[colIdx] = cls._autoIncrementValue
            else:
                cls.fixAutoIncrementValue(idxVal)

        # new data
        obj = cls.dataClass(fields)
        for index in descriptor.indexList:
            index.addObj(obj)

        cls.all.add(obj)

        writeable = descriptor.writeable
        if writeable:
            cls.record_pk.add(primaryKey(cls, fields))
        if writeable and _doTrace:
            cls.record_insert_set.add(obj)
            cls.size += 1
            traceNew(cls, fields)
        return

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
        if value < cls._autoIncrementValue:
            return

        q, r = divmod(value, cls._incrementStep)
        if r == cls._incrementSuffix:
            cls._autoIncrementValue = value
        else:
            cls._autoIncrementValue = q * cls._incrementStep + cls._incrementSuffix
        return

    @classmethod
    def config(cls, conn):
        if cls.isConfig:
            return

        descriptor = cls.descriptor

        if not descriptor:
            raise TypeError("config not descriptor", descriptor)

        # if cls._autoIncrementValue <= 0:
        #     raise ValueError("config _autoIncrementValue error", cls)

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
        descriptor = cls.descriptor
        kvs = [(k, v) for k, v in kw.items() if not isinstance(v, set)]
        values = ['`%s`=%s' % (k, escape(v)) for k, v in kvs]
        kvs = [(k, v) for k, v in kw.items() if isinstance(v, set)]
        sets = ['`%s` in (%s)' % (k, ','.join([escape(v) for v in s]) or 'null') for k, s in kvs]
        _sql = [sql_condition] if sql_condition != '' else []
        condition = ' and '.join(values + sets + _sql)
        _sql_select = cls.sql_select + (' where ' + condition if len(condition) != 0 else '')
        rs = conn.query(_sql_select)
        for r in rs:
            if descriptor.writeable:
                pk = primaryKey(cls, r)
                if pk not in cls.record_pk and pk not in cls.record_pk_delete:
                    cls.new(r, _doTrace=False)
            else:
                _r = list(r)
                for i, v in enumerate(_r):
                    dec = descriptor.fieldList[i].decode
                    if dec is not None:
                        _r[i] = dec(v)
                cls.new(_r, _doTrace=False)
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
            idxName = index.idxName
            assert not hasattr(cls, idxName), 'Index name "%s" duplication.' % idxName
            setattr(cls, idxName, index)
        return

    @classmethod
    def readonly(cls):
        raise AttributeError('%s is none writeable.' % cls.__class__)

    @classmethod
    def initAll(cls):
        if not cls.descriptor:
            raise Exception("initAll need descriptor", cls.__name__, cls.__class__)
        cls.initSql()
        cls.initIndexMethod()
        cls.initDataClass()
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

        class Data(metaclass=PropertyMeta):
            __slots__ = ['cls', 'fields', 'fmt']

            def __init__(self, fields):
                self.cls = cls
                self.fields = fields
                self.fmt = '\n'.join(['  %s: %%s' % field.name for field in self.cls.descriptor.fieldList])

            def __str__(self):
                return '<%s %s>' % (self.__class__.__name__, self.cls.descriptor.tbl)

            def __repr__(self):
                return self.__str__()

            def remove(self):
                writeable = self.cls.descriptor.writeable
                self.cls.all.discard(self)
                self.cls.record_delete_set.add(self)
                self.cls.record_pk.discard(primaryKey(cls, self.fields))
                self.cls.record_pk_delete.add(primaryKey(cls, self.fields))
                self.cls.size -= 1
                if writeable:
                    traceDelete('111', self.toString())
                del self
                return

            def toString(self):
                s = ('{\n' + (self.fmt % tuple(self.fields)) + '\n}\n')
                return s

            def setChanged(self):
                self.cls.record_update_set.add(self)
                return

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
            if type(field.default) is not type(value):
                raise TypeError(field, "default type error", field.default, value)

            beforeVal = obj.fields[idx]
            if beforeVal == value:
                return
            if field.name in descriptor.primaryIndex.cols:
                raise Exception("Can't modify primary key")

            for index in affectIndexList:
                index.removeObj(obj)

            obj.fields[idx] = value

            for index in affectIndexList:
                index.addObj(obj)

            obj.setChanged()
            traceChange(obj.fields, beforeVal, value)
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


def primaryKey(cls, row):
    tupKey = tuple([row[i] for i in cls.descriptor.primaryIndex.colsIndex])
    return tupKey
