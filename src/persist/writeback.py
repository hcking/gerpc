# coding=utf8


from persist.trace import Trace
from persist.fn import getPrimaryValue, escape

from util.logger import getLogger

log = getLogger(__name__)

WriteBackList = []


class WriteBack:
    def __init__(self, cls):
        self._isPreSave = False

        self.cls = cls

        self.record_pk = set()  # record all data pk
        self.record_pk_delete = set()  # record delete data pk

        # current data
        self.record_delete = set()
        self.record_update = set()
        self.record_insert = set()

        # writeBack use data
        self.record_delete_old = set()
        self.record_update_old = set()
        self.record_insert_old = set()

    def _preSave(self):
        if self._isPreSave:
            return

        self.record_delete_old = self.record_delete
        self.record_update_old = self.record_update
        self.record_insert_old = self.record_insert

        self.record_delete = set()
        self.record_update = set()
        self.record_insert = set()

        self._isPreSave = True
        return

    def _success(self):
        if not self._isPreSave:
            return

        self.record_delete_old = set()
        self.record_update_old = set()
        self.record_insert_old = set()
        self.record_pk_delete = set()

        self._isPreSave = False
        return

    def _fail(self):
        if not self._isPreSave:
            return

        self.record_delete.update(self.record_delete_old)
        self.record_update.update(self.record_update_old)
        self.record_insert.update(self.record_insert_old)

        self.record_delete_old = set()
        self.record_update_old = set()
        self.record_insert_old = set()

        self._isPreSave = False
        return

    def incrementSave(self, conn):
        self._preSave()

        ok = True
        obj = None
        sql = None

        try:
            # delete
            deleteSet = self.record_delete_old - self.record_insert_old
            for obj in deleteSet:
                pass

            # insert
            insertSet = self.record_insert_old - self.record_delete_old
            for obj in insertSet:
                sql = mergeSql(obj.cls.sql_insert, tuple(obj.data.values()))
                conn.query(sql)

            # change
            changeSet = self.record_update_old - self.record_delete_old - self.record_insert_old
            for obj in changeSet:
                pass
        except Exception as ex:
            log.error('incrementSave Error,,,%s,,,%s,,,%s', obj, sql, ex)
            ok = False

        if ok:
            self._success()
        else:
            self._fail()
        return ok


def newWriteBack(cls):
    if not cls.descriptor.writeable:
        return None

    global WriteBackList
    wb = WriteBack(cls)
    if wb not in WriteBackList:
        WriteBackList.append(wb)
    return wb


def changeObj(cls, obj, beforeVal, value, attr):
    if not cls.descriptor.writeable:
        return
    cls.writeBack.record_update.add(obj)
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
        cls.writeBack.record_delete.add(obj)
        pkVal = getPrimaryValue(obj.data, cls.descriptor)
        cls.writeBack.record_pk.discard(pkVal)
        cls.writeBack.record_pk_delete.add(pkVal)
        Trace.traceDelete(
            tbl=cls.descriptor.tbl,
            pkVal=pkVal,
        )
    return


def newObj(cls, obj, _doTrace):
    if not cls.descriptor.writeable:
        return
    pkVal = getPrimaryValue(obj.data, cls.descriptor)
    cls.writeBack.record_pk.add(pkVal)
    if _doTrace:
        cls.writeBack.record_insert.add(obj)
        Trace.traceNew(cls.descriptor.tbl, tuple(obj.data.values()))
    return


def incrementSaveAll(conn):
    conn.query('start transaction;')
    ok = True
    for wb in WriteBackList:
        ok = wb.incrementSave(conn)
        if not ok:
            break
    if ok:
        conn.query('commit;')
        log.info("incrementSaveAll success")
    else:
        conn.query('rollback;')
        log.info("incrementSaveAll fail")
    return ok


def mergeSql(sql, values):
    params = tuple(escape(v) for v in values)
    _sql = sql % params
    print(sql)
    return _sql
