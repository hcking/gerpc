from persist.catty import *
from persist.loader import *

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
