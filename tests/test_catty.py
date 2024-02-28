# coding=utf8

import unittest

from data.card import (
    Role,
)
from util.dbpool import getConn


class CattyTest(unittest.TestCase):
    conn = getConn()

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_load(self):
        # load one
        Role.load(self.conn, role_id=200001)
        # load all
        Role.load(self.conn)
        return

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

    def test_getByIndex(self):
        roles = Role.all()
        if roles:
            for r in list(roles):
                r.remove()

        role1 = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        _ = Role.new(
            role_id=0,
            name="test2",
            account="test2@test",
            gold=10,
        )
        _ = Role.new(
            role_id=0,
            name="test3",
            account="test3@test",
            gold=10,
        )
        role2 = Role.getByIndex('Role_Id_Idx', role_id=role1.get('role_id'))
        self.assertTrue(role1 is role2)
        t = Role.getByIndex('Name_Idx', name='test1')
        self.assertTrue(role1 is t)
        self.assertTrue(len(Role.all()) == 3)
        return


if __name__ == '__main__':
    unittest.main()
