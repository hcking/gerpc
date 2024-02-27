# conding=utf8
import os.path

from configure import Configure
import logging
from logging.handlers import TimedRotatingFileHandler


def getLogger(name, logPath=None, level=None, handler=None, logFormat=None):
    logger = logging.getLogger(name)
    logLevel = level or Configure.logLevel
    logger.setLevel(logLevel)

    logPath = logPath or Configure.logPath
    d = os.path.dirname(logPath)
    fullPath = os.path.abspath(d)
    if not os.path.exists(fullPath):
        os.makedirs(fullPath)

    if not handler:
        handler = TimedRotatingFileHandler(Configure.logPath, when='midnight', interval=1, backupCount=30)
        handler.setLevel(logLevel)

    logFormat = logFormat or logging.Formatter('%(asctime)s %(filename)s %(levelname)s:%(message)s')

    handler.setFormatter(logFormat)
    logger.addHandler(handler)
    return logger
