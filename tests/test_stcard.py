# coding=utf8

import unittest

from data.stcard import (
    TableStConst,
    TableStGold77Bonus,
    TableStAttributeIndex,
)


class Test(unittest.TestCase):

    def test_load(self):
        TableStConst.loadcsv()
        TableStGold77Bonus.loadcsv()
        TableStAttributeIndex.loadcsv()
        conf183 = TableStGold77Bonus.getByIndex('Playerlv_Idx', playerlv=183)
        print(conf183)
        TableStGold77Bonus.reload()
        conf183 = TableStGold77Bonus.getByIndex('Playerlv_Idx', playerlv=183)
        print(conf183)
        self.assertEqual(1, 1)

    def test_reload(self):
        TableStConst.loadcsv()
        len1 = len(TableStConst.all())
        TableStConst.reload()
        len2 = len(TableStConst.all())
        self.assertEqual(len1, len2)
        confMaxPower = TableStConst.getByIndex('Constname_Idx', constname='maxpower')
        self.assertTrue(confMaxPower)
        return
