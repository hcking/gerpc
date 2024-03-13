from persist.catty import (
    Descriptor,
    FieldDescriptor,
    HashIndex,
    CattyBase,
    CattyMeta,
)


class TableStConst(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='st_const',
        tbl='st_const',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='constName',
                default="",
                colName='A',
            ),
            FieldDescriptor(
                name='value',
                default=0,
                colName='B',
            ),
        ],
        indexList=[
            HashIndex(
                cols=('constName',),
                unique=True,
            ),
        ],
    )


class TableStGold77Bonus(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='st_gold77bonus',
        tbl='st_gold77bonus',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='playerlv',
                default="",
                colName='A',
            ),
            FieldDescriptor(
                name='bonusratio',
                default=0,
                colName='B',
            ),
        ],
        indexList=[
            HashIndex(
                cols=('playerlv',),
                unique=True,
            ),
        ],
    )


class TableStAttributeIndex(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='st_attributeindex',
        tbl='st_attributeindex',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='id',
                default="",
                colName='A',
            ),
            FieldDescriptor(
                name='attriname',
                default=0,
                colName='B',
            ),
            FieldDescriptor(
                name='attributetype',
                default=0,
                colName='C',
            ),
            FieldDescriptor(
                name='floatnum',
                default=0,
                colName='D',
            ),
            FieldDescriptor(
                name='type',
                default=0,
                colName='E',
            ),
            FieldDescriptor(
                name='attrirow',
                default=0,
                colName='G',
            ),
            FieldDescriptor(
                name='attricolumn',
                default=0,
                colName='H',
            ),
        ],
        indexList=[
            HashIndex(
                cols=('playerlv',),
                unique=True,
            ),
        ],
    )


reloadDataList = [
    TableStConst,
    TableStGold77Bonus,
    TableStAttributeIndex
]


def loadReloadDataList():
    for t in reloadDataList:
        t.loadFromCache()
    return
