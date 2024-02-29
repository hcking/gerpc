import unittest

from data.card import (
    Role,
)
from util.dbpool import getConn
from persist.writeback import incrementSaveAll


class CattyTest(unittest.TestCase):
    conn = getConn()

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_load(self):
        Role.load(self.conn, role_id=100000)
        Role.load(self.conn, role_id=100000)
        Role.load(self.conn, role_id=100000)
        # Role.limit_load(self.conn, 0, 100)
        # Role.limit_load(self.conn, 0, 100)
        # role = Role.getByIndex('Role_Id_Idx', role_id=100000)

        # Role.limit_load_all(self.conn)
        self.assertTrue(1)
        return

    def test_writeBack(self):
        role = Role.new(
            role_id=0,
            name="test1",
            account="test1@test",
            gold=10,
        )
        role.set('gold', 100000)
        res = incrementSaveAll(self.conn)
        self.assertTrue(res)

        res = incrementSaveAll(self.conn)
        self.assertTrue(res)

        return
