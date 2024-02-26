# coding=utf8

from util.log import getLogger

log = getLogger(__name__)

WriteableClass = {}


class Trace:
    _separator = ',,,'

    def __new__(cls, *args, **kwargs):
        raise NotImplementedError

    @classmethod
    def traceDelete(cls, tbl, pkVal):
        s = cls._separator.join([
            'traceDelete',
            tbl,
            str(pkVal),
        ])
        cls._record(s)
        return

    @classmethod
    def traceChange(cls, tbl, pkVal, attrName, old, new):
        s = cls._separator.join([
            'traceChange',
            tbl,
            str(pkVal),
            attrName,
            str(old),
            str(new),
        ])
        cls._record(s)
        return

    @classmethod
    def traceNew(cls, tbl, fields):
        s = cls._separator.join([
            'traceNew',
            tbl,
            str(fields),
        ])
        cls._record(s)
        return

    @classmethod
    def _record(cls, s):
        print(s)
        log.info(s)
        return


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
