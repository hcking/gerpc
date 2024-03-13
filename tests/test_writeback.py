import unittest

from data.card import (
    Role,
)
from util.dbpool import getConn
from persist.writeback import incrementSaveAll


class Test(unittest.TestCase):
    conn = getConn()

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_load_all(self):
        Role.load(self.conn)
        len1 = len(Role.all())
        Role.limit_load_all(self.conn)
        len2 = len(Role.all())
        self.assertEqual(len1, len2)
        return

    def test_incrementSaveAll(self):
        with self.assertRaises(Exception):
            Role.new(
                role_id=0,
                name="test1",
                account="test1@test",
                gold=10,
            )

        Role.limit_load_all(self.conn)
        role = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        role_id = role.get('role_id')
        role2 = Role.getByIndex('Role_Id_Idx', role_id=role_id)
        self.assertTrue(role is role2)
        role.set('gold', 100000)

        role2 = Role.new(
            role_id=0,
            name="test2",
            account="test2@test",
            gold=20,
        )
        role2.set('gold', 2000)
        role2.remove()

        res = incrementSaveAll(self.conn)
        self.assertTrue(res)
        return
