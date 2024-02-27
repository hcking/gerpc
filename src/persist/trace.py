# coding=utf8

import inspect
from util.logger import getLogger

log = getLogger(__name__)


class Trace:
    def __new__(cls, *args, **kwargs):
        raise NotImplementedError

    @classmethod
    def traceDelete(cls, tbl, pkVal):
        filename, lineno = cls._getTraceParams()
        recordTuple = (
            filename,
            lineno,
            'traceDelete',
            tbl,
            str(pkVal),
        )
        cls._record(recordTuple)
        return

    @classmethod
    def traceChange(cls, tbl, pkVal, attrName, old, new):
        filename, lineno = cls._getTraceParams()

        recordTuple = (
            filename,
            lineno,
            'traceChange',
            tbl,
            str(pkVal),
            attrName,
            str(old),
            str(new),
        )
        cls._record(recordTuple)
        return

    @classmethod
    def traceNew(cls, tbl, fields):
        filename, lineno = cls._getTraceParams()
        recordTuple = (
            filename,
            lineno,
            'traceNew',
            tbl,
            fields,
        )
        cls._record(recordTuple)
        return

    @classmethod
    def _record(cls, recordTuple):
        s = str(recordTuple)
        print(s)
        log.info(s)
        return

    @classmethod
    def _getTraceParams(cls):
        frame = inspect.currentframe()
        caller = frame.f_back.f_back.f_back.f_back
        filename = caller.f_code.co_filename
        lineno = caller.f_lineno
        return filename, lineno
