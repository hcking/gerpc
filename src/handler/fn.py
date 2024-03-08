# coding=utf8

from data.card import (
    Role,
    RoleMailList,
)


def Success(resp, ex=None):
    resp.succeed = True
    if ex:
        resp.extra = ex
    return


def Fail(resp, ex=None):
    resp.succeed = False
    if ex is not None:
        resp.extra = ex
    return


def GetRoleByContext(context):
    return GetRoleById(context.role_id)


def GetRoleById(role_id):
    return Role.getByIndex('Role_Id_Idx', role_id=role_id)
