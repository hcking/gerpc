# coding=utf8

from myorm import (
    Descriptor,
    FieldDescriptor,
    HashIndex,
    DataBase,
    DataMeta,
)

autoIncrementSuffix = 10
DataBase.setAutoIncrementSuffix(autoIncrementSuffix)

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
        ),
        HashIndex(
            cols=('lv',),
        ),
    ],
)


class Role(DataBase, metaclass=DataMeta):
    descriptor = _SD_ROLE_PD


LoadAllList = [
    Role,
]


def load_card(conn):
    for tab in LoadAllList:
        tab.config(conn)
        tab.load(conn)


def main():
    from db import getConn
    conn = getConn()
    # Role.load(conn, lv=230)
    Role.load(conn, role_id=204680010)
    Role.load(conn, role_id=204750010)
    Role.load(conn, role_id=204700010)
    Role.load(conn, role_id=204710010)

    role1 = Role.Role_Id_Idx(role_id=204680010)
    print(role1.role_id, role1.name, role1.lv, role1)
    role1.lv = 20
    return


if __name__ == '__main__':
    main()
