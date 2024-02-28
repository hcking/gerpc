# coding=utf8

import unittest

from data.card import (
    Role,
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

    def test_change(self):
        role = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        role_id = role.get('role_id')
        role2 = Role.new(
            name='test2',
            account='test2@test'
        )
        self.assertTrue(role_id > 0)
        self.assertEqual(role.get('gold'), 10)
        role2_id = role2.get('role_id')
        self.assertTrue(role2_id > role_id)
        role.set('gold', 20)

        role.set('token', 30)
        role.set('token', 30)
        role.set('token', 30)
        self.assertEqual(role.get('gold'), 20)

        with self.assertRaises(Exception):
            role.set('gold', 'abcd')

        with self.assertRaises(Exception):
            role._unknown = 1

        with self.assertRaises(Exception):
            role.set('_unknown', 1)

        with self.assertRaises(Exception):
            role.set('role_id', 1)

        return


if __name__ == '__main__':
    unittest.main()
