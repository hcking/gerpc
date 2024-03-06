# conding=utf8


import os.path
import logging

from logging.handlers import TimedRotatingFileHandler
from configure import Configure

defaultTimedRotatingFileHandler = TimedRotatingFileHandler(
    Configure.logPath,
    when='midnight',
)

_isInit = False


def init():
    global _isInit
    if _isInit:
        return

    checkPath(Configure.logPath)
    handler = defaultTimedRotatingFileHandler
    logFormat = logging.Formatter('%(asctime)s %(filename)s %(levelname)s:%(message)s')
    handler.setLevel(Configure.logLevel)
    handler.setFormatter(logFormat)
    name = ''
    logger = logging.getLogger(name)
    logger.addHandler(handler)

    _isInit = True
    return logger


def checkPath(logPath):
    d = os.path.dirname(logPath)
    fullPath = os.path.abspath(d)
    if not os.path.exists(fullPath):
        os.makedirs(fullPath)
    return


def getLogger(name='', level=Configure.logLevel):
    if not _isInit:
        init()

    logger = logging.getLogger(name)
    logger.setLevel(level)
    return logger
