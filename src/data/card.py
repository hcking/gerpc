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

_SD_ROLE_PD = Descriptor(
    name='roles',
    tbl='roles',
    writeable=True,
    fieldList=[
        FieldDescriptor(
            name='role_id',
            kind='bigint unsigned not null default 0 ',
            default=0,
        ),
        FieldDescriptor(
            name='account',
            kind='varchar(48) not null',
            default="",
        ),
        FieldDescriptor(
            name='name',
            kind='varchar(20) not null',
            default="",
        ),
        FieldDescriptor(
            name='physical',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='endurance',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='invitationTicket',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='lv',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='exp',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='gold',
            kind='bigint unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='token',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='memberPresetNo',
            kind='int unsigned not null',
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
            cols=('lv',),
        ),
    ],
)

_SD_MAIL_LIST_PD = Descriptor(
    name='_mail_list_',
    tbl='mail_list',
    writeable=True,
    fieldList=[
        FieldDescriptor(
            name='mail_id',
            kind='bigint unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='type',
            kind='int not null',
            default=0,
        ),
        FieldDescriptor(
            name='content',
            kind='varchar(128)',
            default="",
        ),
        FieldDescriptor(
            name='sender_roleid',
            kind='bigint unsigned',
            default=0,
        ),
        FieldDescriptor(
            name='receiver_number',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='stime',
            kind='int unsigned not null',
            default=0,
        ),
        FieldDescriptor(
            name='send_serverid',
            kind='int unsigned not null',
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


class Role(CattyBase, metaclass=CattyMeta):
    descriptor = _SD_ROLE_PD


class Role_MailList(CattyBase, metaclass=CattyMeta):
    descriptor = _SD_MAIL_LIST_PD


LoadAllList = [
    Role,
    Role_MailList,
]


def loadFromLoadAllList(conn):
    for tab in LoadAllList:
        tab.load(conn)
    return
