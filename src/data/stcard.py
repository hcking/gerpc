from persist.catty import (
    CattyBase,
    CattyMeta,
)


class TableStConst(CattyBase, metaclass=CattyMeta):
    from data.extend import st_const
    source = st_const
    descriptor = source.descriptor


class TableStGold77Bonus(CattyBase, metaclass=CattyMeta):
    from data.extend import st_gold77bonus
    source = st_gold77bonus
    descriptor = source.descriptor


class TableStAttributeIndex(CattyBase, metaclass=CattyMeta):
    from data.extend import st_attributeindex
    source = st_attributeindex
    descriptor = source.descriptor


reloadDataList = [
    TableStConst,
    TableStGold77Bonus,
    TableStAttributeIndex
]


def loadReloadDataList():
    for t in reloadDataList:
        t.loadcsv()
    return
