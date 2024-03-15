from persist.catty import *
from persist.loader import *

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
