# coding=utf8

from data.card import Role, Role_MailList

cfg = {
    Role: 22000,
    Role_MailList: 30000,
}


def getLoadLimit(cls):
    if cls in cfg:
        return cfg[cls]
    return 50000
