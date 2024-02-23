# coding=utf-8


CRITICAL = 50
FATAL = CRITICAL
ERROR = 40
WARNING = 30
WARN = WARNING
INFO = 20
DEBUG = 10
NOTSET = 0


class Configure:
    address = ("127.0.0.1", 11)
    logPath = 'log/server.log'
    logLevel = INFO
    backdoor = False
