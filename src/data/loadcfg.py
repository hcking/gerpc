# coding=utf8

from data.card import Role, RoleMailList

cfg = {
    Role: 22000,
    RoleMailList: 30000,
}


def getLoadLimit(cls):
    if cls in cfg:
        return cfg[cls]
    return 50000
