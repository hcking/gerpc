# coding=utf8
import sys

import gevent
from gevent import event
from persist.trace import Trace
from persist.fn import getPrimaryValue, escape

from util.dbpool import getConn
from util.logger import getLogger

log = getLogger(__name__)

WriteBackList = []


class WriteBack:
    def __init__(self, cls):
        self._isPreSave = False

        self.cls = cls

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
                keys = getPrimaryValue(obj.data, self.cls.descriptor)
                sql = mergeSql(obj.cls.sql_delete, keys)
                conn.query(sql)

            # insert
            insertSet = self.record_insert_old - self.record_delete_old
            for obj in insertSet:
                sql = mergeSql(obj.cls.sql_insert, tuple(obj.data.values()))
                conn.query(sql)

            # change
            changeSet = self.record_update_old - self.record_delete_old - self.record_insert_old
            for obj in changeSet:
                keys = tuple(obj.data.values()) + getPrimaryValue(obj.data, self.cls.descriptor)
                sql = mergeSql(obj.cls.sql_update, keys)
                conn.query(sql)

        except Exception as ex:
            log.error('incrementSave Error,,,%s,,,%s,,,%s', obj, sql, ex)
            ok = False

        if ok:
            self._success()
        else:
            self._fail()
        return ok


def newWriteBack(cls):
    global WriteBackList
    wb = WriteBack(cls)
    if cls.descriptor.writeable and wb not in WriteBackList:
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
    pkVal = getPrimaryValue(obj.data, cls.descriptor)
    cls._all_pk.discard(pkVal)

    for index in cls.descriptor.indexList:
        index.removeObj(obj)

    if cls.descriptor.writeable:
        cls.writeBack.record_delete.add(obj)
        cls.writeBack.record_pk_delete.add(pkVal)
        Trace.traceDelete(
            tbl=cls.descriptor.tbl,
            pkVal=pkVal,
        )
    return


def newObj(cls, obj, _doTrace):
    if _doTrace:
        cls.writeBack.record_insert.add(obj)
        Trace.traceNew(cls.descriptor.tbl, tuple(obj.data.values()))
    return


def incrementSaveAll(conn=None):
    log.info("incrementSaveAll begin")
    if not conn:
        conn = getConn()
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
    s = sql % params
    return s


_saveLet = None
_interval = 60 * 5

IntervalMin = 60
IntervalMax = 60 * 60


def setInterval(sec):
    global _interval

    if not isinstance(sec, int):
        return False
    if sec < IntervalMin:
        sec = IntervalMin
    if sec > IntervalMax:
        sec = IntervalMax
    old = _interval
    _interval = sec
    log.warning('setInterval %s,%s', old, _interval)
    return True


_running = True
stop_event = event.Event()


def defaultSave():
    global _running, stop_event
    log.warning("defaultSave start")
    while _running:
        # print('defaultSave')
        for n in range(_interval):
            # print('defaultSave step', n, _interval)
            gevent.sleep(1)
            if not _running:
                break
        stop_event.clear()
        incrementSaveAll()
        stop_event.set()

    log.warning("defaultSave exit")
    return


def windowsSave():
    defaultSave()
    return


def linuxSave():
    # todo use fork
    defaultSave()
    return


if sys.platform.startswith('win'):
    doSave = windowsSave
else:
    doSave = linuxSave


def startTimerWriteBack():
    global _saveLet
    if _saveLet:
        return

    _saveLet = gevent.spawn(doSave)
    return


def stopTimerWriteBack():
    global _running, _saveLet
    _running = False
    stop_event.wait()
    _saveLet = None
    return
