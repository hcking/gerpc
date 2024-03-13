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

        self.assertEqual(1, 1)
