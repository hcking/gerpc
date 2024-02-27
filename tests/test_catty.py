# coding=utf8

import time
import unittest

from data.card import (
    Role,
    Role_MailList,
)
from util.dbpool import MyConnect

dbconfig = {
    "host": "172.16.16.59",
    "port": 3306,
    "user": "root",
    "passwd": "zhengtu#123.com",
    "db": "atm_test_tzz",
}


class CattyTest(unittest.TestCase):
    conn = MyConnect(**dbconfig)

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_load(self):
        role_id = 256470010  # exist
        res = Role.load(self.conn, role_id=role_id)
        self.assertEqual(res, None, 'load not return')
        role = Role.get('Role_Id_Idx', role_id=role_id)
        if role:
            print('test_load ok')
        # self.assertTrue(role.get('role_id') == role_id)
        return

    def test_change(self):
        role = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=0,
            token=0,
        )

        self.assertTrue(role.get('role_id') > 0)
        role.set('gold', 20)
        role.set('token', 30)
        self.assertEqual(role.get('gold'), 20)

        with self.assertRaises(Exception):
            role.set('gold', 'abcd')

        with self.assertRaises(Exception):
            role._unknown = 1

        with self.assertRaises(Exception):
            role.set('role_id', 1)

        Role_MailList.load(self.conn, mail_id=137860010)
        nowTime = int(time.time())
        m = Role_MailList.new(
            mail_id=0,
            type=1,
            content="test",
            stime=nowTime,
        )
        self.assertTrue(m)
        self.assertTrue(m.get('mail_id') > 0)
        self.assertEqual(m.get('type'), 1)
        self.assertEqual(m.get('stime'), nowTime)

        return


if __name__ == '__main__':
    unittest.main()
