import os
from persist.catty import *
from persist.loader import *

absPath = os.path.abspath(__file__)
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
