# coding=utf8

import pymysql

from configure import dbConfig

_conn = None


class MyConnect(object):
    def __init__(self, host, port, user, passwd, db):
        self.connect = pymysql.connect(host=host, user=user, port=port, db=db, passwd=passwd)
        self.connect.connect()

    def query(self, sql):
        assert isinstance(sql, str)
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

    def close(self):
        self.connect.close()
        return


def getConn():

    global _conn
    if _conn:
        return _conn
    return MyConnect(**dbConfig)
