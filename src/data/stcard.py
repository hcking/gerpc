from persist.catty import (
    Descriptor,
    FieldDescriptor,
    HashIndex,
    CattyBase,
    CattyMeta,
)
from persist.loader import (
    defaultInt,
    defaultStr,
    defaultFloat,
)


class TableStConst(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='玩家信息表.xlsx',
        tbl='st_const',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='constname',
                default=defaultStr,
                colName='A',
            ),
            FieldDescriptor(
                name='value',
                default=defaultInt,
                colName='B',
            ),
        ],
        indexList=[
            HashIndex(
                cols=('constname',),
                unique=True,
            ),
        ],
    )


class TableStGold77Bonus(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='玩家信息表.xlsx',
        tbl='st_gold77bonus',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='playerlv',
                default=defaultInt,
                colName='A',
            ),
            FieldDescriptor(
                name='bonusratio',
                default=defaultFloat,
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
        name='玩家信息表.xlsx',
        tbl='st_attributeindex',
        writeable=False,
        fieldList=[
            FieldDescriptor(
                name='id',
                default=defaultInt,
                colName='A',
            ),
            FieldDescriptor(
                name='attriname',
                default=defaultStr,
                colName='B',
            ),
            FieldDescriptor(
                name='attributetype',
                default=defaultInt,
                colName='C',
            ),
            FieldDescriptor(
                name='floatnum',
                default=defaultInt,
                colName='D',
            ),
            FieldDescriptor(
                name='type',
                default=defaultInt,
                colName='E',
            ),
            FieldDescriptor(
                name='attrirow',
                default=defaultInt,
                colName='G',
            ),
            FieldDescriptor(
                name='attricolumn',
                default=defaultInt,
                colName='H',
            ),
        ],
        indexList=[
            HashIndex(
                cols=('id',),
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
        t.loadcsv()
    return
