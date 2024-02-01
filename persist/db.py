# coding=utf8


import pymysql
from configure import dbconfig

_g_connect = None


def getConn():
    global _g_connect
    if _g_connect:
        return _g_connect

    _g_connect = MyConnect(dbconfig)
    return _g_connect


class MyConnect(object):
    def __init__(self, dbconfig):
        self.connect = pymysql.connect(**dbconfig)
        self.connect.connect()

    def query(self, sql):
        if not isinstance(sql, str):
            raise TypeError('query error', type(sql), sql)
        with self.connect.cursor() as cur:
            cur.execute(sql)
            res = cur.fetchall()
        return res

    def getAutoIncrement(self, tbl):
        findIndex = 0
        sql = 'show table status where name="{}";'.format(tbl)
        with self.connect.cursor() as cur:
            cur.execute(sql)
            for index, val in enumerate(cur.description):
                if val[0].lower() == "auto_increment":
                    findIndex = index
                    break
            if not findIndex:
                raise ValueError('getAutoIncrement error', tbl)
            res = cur.fetchone()
        return res[findIndex]
