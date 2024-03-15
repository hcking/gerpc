# coding=utf8

import unittest

from data.stcard import (
    TableStConst,
    TableStGold77Bonus,
    TableStAttributeIndex,
)
import os

absPathFile = os.path.abspath(__file__)


class Test(unittest.TestCase):

    def test_load(self):
        TableStConst.loadcsv()
        TableStGold77Bonus.loadcsv()
        TableStAttributeIndex.loadcsv()
        conf_183_1 = TableStGold77Bonus.getByIndex('Playerlv_Idx', playerlv=183)
        self.assertTrue(conf_183_1)
        TableStGold77Bonus.reload()
        conf_183_2 = TableStGold77Bonus.getByIndex('Playerlv_Idx', playerlv=183)
        self.assertTrue(conf_183_2)
        self.assertEqual(conf_183_1.get('playerlv'), conf_183_2.get('playerlv'))

    def test_reload(self):
        TableStConst.loadcsv()
        len1 = len(TableStConst.all())
        TableStConst.reload()
        len2 = len(TableStConst.all())
        self.assertEqual(len1, len2)
        confMaxPower = TableStConst.getByIndex('Constname_Idx', constname='maxpower')
        self.assertTrue(confMaxPower)
        return
