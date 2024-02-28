# coding=utf8
from persist.trace import Trace
from persist.fn import getPrimaryValue

WriteBackList = []


class WriteBack:
    def __init__(self, cls):
        self.cls = cls
        self.record_delete = set()
        self.record_update = set()
        self.record_insert = set()
        self.record_pk = set()
        self.record_pk_delete = set()


def newWriteBack(cls):
    if not cls.descriptor.writeable:
        return
    global WriteBackList
    obj = WriteBack(cls)
    if obj not in WriteBackList:
        WriteBackList.append(obj)
    return obj


def changeObj(cls, obj, beforeVal, value, attr):
    if not cls.descriptor.writeable:
        return
    cls._writeBack.record_update.add(obj)
    Trace.traceChange(
        tbl=cls.descriptor.tbl,
        pkVal=getPrimaryValue(obj.data, cls.descriptor),
        attrName=attr,
        old=beforeVal,
        new=value,
    )
    return


def removeObj(cls, obj):
    cls._all.discard(obj)
    if cls.descriptor.writeable:
        cls._writeBack.record_delete.add(obj)
        pkVal = getPrimaryValue(obj.data, cls.descriptor)
        cls._writeBack.record_pk.discard(pkVal)
        cls._writeBack.record_pk_delete.add(pkVal)
        Trace.traceDelete(
            tbl=cls.descriptor.tbl,
            pkVal=pkVal,
        )
    return


def newObj(cls, obj, _doTrace):
    if not cls.descriptor.writeable:
        return
    cls._writeBack.record_pk.add(getPrimaryValue(obj.data, cls.descriptor))
    if _doTrace:
        cls._writeBack.record_insert.add(obj)
        Trace.traceNew(cls.descriptor.tbl, tuple(obj.data.values()))
    return


def incrementSave(cls):
    writeBack = cls._writeBacks
    if not writeBack:
        return False
    return True


def incrementSaveAll():
    for cls in WriteBackList:
        ok = incrementSave(cls)
        if not ok:
            return False
    return True
