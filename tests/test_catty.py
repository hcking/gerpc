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

    def test_default_unique(self):
        Role.limit_load_all(self.conn)
        with self.assertRaises(Exception):
            Role.new()

        role1 = Role.new(
            role_id=0,
            name='name1',
            account='account1'
        )
        role2 = Role.new(
            role_id=0,
            name='name2',
            account='account2'
        )
        name = role1.get('name')
        with self.assertRaises(Exception):
            role2.set('name', name)
        Role.clean(force=True)
        return

    def test_new_unique_index(self):
        Role.limit_load_all(self.conn)

        # repeat name
        name = 'name1'
        account = 'account1'
        _ = Role.new(
            role_id=0,
            name=name,
            account=account,
        )
        with self.assertRaises(Exception):
            _ = Role.new(
                role_id=0,
                name=name,
            )
        with self.assertRaises(Exception):
            _ = Role.new(
                role_id=0,
                account=account,
            )
        Role.clean(force=True)
        return

    def test_change(self):
        Role.limit_load_all(self.conn)
        Role.clean(force=True)
        role = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        role_id = role.get('role_id')
        role2 = Role.new(
            role_id=0,
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
        Role.clean(force=True)
        return

    def test_getByIndex(self):
        Role.limit_load_all(self.conn)
        Role.clean(force=True)
        role1 = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        role2 = Role.new(
            role_id=0,
            name="test2",
            account="test2@test",
            gold=10,
        )
        role3 = Role.new(
            role_id=0,
            name="test3",
            account="test3@test",
            gold=10,
        )
        role2.remove()
        role3.remove()
        role2 = Role.getByIndex('Role_Id_Idx', role_id=role1.get('role_id'))
        self.assertTrue(role1 is role2)
        t = Role.getByIndex('Name_Idx', name='test1')
        self.assertTrue(role1 is t)
        Role.clean(force=True)
        return


if __name__ == '__main__':
    unittest.main()
