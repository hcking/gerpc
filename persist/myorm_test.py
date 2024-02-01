# coding=utf8

import time
import unittest

from card import (
    Role,
    Role_MailList,
)

from db import getConn


class MyOrmTest(unittest.TestCase):
    conn = None

    @classmethod
    def setUpClass(cls):
        cls.conn = getConn()

    def setUp(self):
        pass

    def test_one(self):
        print(Role.getIndexName())
        res = Role.load(self.conn, role_id=204680010)
        self.assertEqual(res, None, 'load not return')
        role = Role.get('Role_Id_Idx', role_id=204680010)
        print(role)
        return

    def test_new(self):
        Role_MailList.load(self.conn, mail_id=137860010)
        m = Role_MailList.new(
            mail_id=10,
            type=1,
            content="test",
            sender_roleid=0,
            receiver_number=0,
            stime=time.time(),
            send_serverid=0,
        )
        print(m)
        return


if __name__ == '__main__':
    unittest.main()
