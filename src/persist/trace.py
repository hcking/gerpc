# coding=utf8

import inspect
import os.path

from configure import Configure
from util.logger import getLogger

log = getLogger(__name__)


class Trace:
    def __new__(cls, *args, **kwargs):
        raise NotImplemented

    @classmethod
    def traceDelete(cls, tbl, pkVal):
        filename, lineno = cls._getTraceParams()
        recordTuple = (
            'traceDelete',
            filename,
            lineno,
            tbl,
            pkVal,
        )
        cls._record(recordTuple)
        return

    @classmethod
    def traceChange(cls, tbl, pkVal, attrName, old, new):
        filename, lineno = cls._getTraceParams()

        recordTuple = (
            'traceChange',
            filename,
            lineno,
            tbl,
            pkVal,
            attrName,
            old,
            new,
        )
        cls._record(recordTuple)
        return

    @classmethod
    def traceNew(cls, tbl, fields):
        filename, lineno = cls._getTraceParams()
        recordTuple = (
            'traceNew',
            filename,
            lineno,
            tbl,
            fields,
        )
        cls._record(recordTuple)
        return

    @classmethod
    def _record(cls, recordTuple):
        s = str(recordTuple)
        if Configure.debugMode:
            print(s)
        log.info(s)
        return

    @classmethod
    def _getTraceParams(cls):
        frame = inspect.currentframe()
        caller = frame.f_back.f_back.f_back.f_back
        filename = caller.f_code.co_filename
        lineno = caller.f_lineno
        basename = os.path.basename(filename)
        return basename, lineno
