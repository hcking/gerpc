# coding=utf-8

class LogLevel:
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
    logLevel = LogLevel.INFO
    backdoor = False
    autoIncrementSuffix = 10
    debugMode = True


dbConfig = {
    "host": "172.16.16.59",
    "port": 3306,
    "user": "root",
    "passwd": "zhengtu#123.com",
    "db": "atm_test_tzz",
}
