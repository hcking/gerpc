# coding=utf8

from persist.catty import (
    Descriptor,
    FieldDescriptor,
    HashIndex,
    Increment,
    CattyBase,
    CattyMeta,
)

from configure import Configure

Increment.setAutoIncrementSuffix(Configure.autoIncrementSuffix)


class Role(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='roles',
        tbl='roles',
        writeable=True,
        fieldList=[
            FieldDescriptor(
                name='role_id',
                default=0,
            ),
            FieldDescriptor(
                name='account',
                default="",
            ),
            FieldDescriptor(
                name='name',
                default="",
            ),
            FieldDescriptor(
                name='physical',
                default=0,
            ),
            FieldDescriptor(
                name='endurance',
                default=0,
            ),
            FieldDescriptor(
                name='invitationTicket',
                default=0,
            ),
            FieldDescriptor(
                name='lv',
                default=0,
            ),
            FieldDescriptor(
                name='exp',
                default=0,
            ),
            FieldDescriptor(
                name='gold',
                default=0,
            ),
            FieldDescriptor(
                name='token',
                default=0,
            ),
            FieldDescriptor(
                name='memberPresetNo',
                default=0,
            ),
        ],
        indexList=[
            HashIndex(
                cols=('role_id',),
                unique=True,
                pk=True,
                auto=True,
            ),
            HashIndex(
                cols=('name',),
                unique=True,
            ),
            HashIndex(
                cols=('account',),
                unique=True,
            ),
            HashIndex(
                cols=('lv',),
            ),
        ],
    )


class RoleMailList(CattyBase, metaclass=CattyMeta):
    descriptor = Descriptor(
        name='_mail_list_',
        tbl='mail_list',
        writeable=True,
        fieldList=[
            FieldDescriptor(
                name='mail_id',
                default=0,
            ),
            FieldDescriptor(
                name='type',
                default=0,
            ),
            FieldDescriptor(
                name='content',
                default="",
            ),

            FieldDescriptor(
                name='receiver_number',
                default=0,
            ),
            FieldDescriptor(
                name='stime',
                default=0,
            ),
        ],
        indexList=[
            HashIndex(
                cols=('mail_id',),
                unique=True,
                pk=True,
                auto=True,
            ),
        ],
    )


LoadAllList = [
    Role,
    RoleMailList,
]


def loadFromLoadAllList(conn):
    for tab in LoadAllList:
        tab.limit_load_all(conn)
    return
