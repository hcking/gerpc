# conding=utf8


import os.path
import logging

from logging.handlers import TimedRotatingFileHandler
from configure import Configure

defaultTimedRotatingFileHandler = None

_isInit = False


def init():
    global defaultTimedRotatingFileHandler, _isInit
    if _isInit:
        return

    checkPath(Configure.logPath)
    h = TimedRotatingFileHandler(
        Configure.logPath,
        when='midnight',
    )
    defaultTimedRotatingFileHandler = h
    _isInit = True
    return


def checkPath(logPath):
    d = os.path.dirname(logPath)
    fullPath = os.path.abspath(d)
    if not os.path.exists(fullPath):
        os.makedirs(fullPath)
    return


def getLogger(name='', logPath=None, level=None, handler=None, logFormat=None):
    if not _isInit:
        init()
    logLevel = level or Configure.logLevel
    logPath = logPath or Configure.logPath
    handler = handler or defaultTimedRotatingFileHandler
    logFormat = logFormat or logging.Formatter('%(asctime)s %(filename)s %(levelname)s:%(message)s')

    logger = logging.getLogger(name)
    logger.setLevel(logLevel)
    checkPath(logPath)

    handler.setLevel(logLevel)
    handler.setFormatter(logFormat)
    logger.addHandler(handler)
    return logger
