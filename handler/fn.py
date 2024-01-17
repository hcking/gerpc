# coding=utf8


def Succ(resp, ex=None):
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
    if role_id:
        return FakeRole(role_id)
    return None


class Role:
    def __init__(self, role_id):
        self.role_id = role_id
        self.name = str(role_id)
        self.age = self.role_id % 100
        self.account = str(self.role_id) + '@' + str(self.role_id)


def FakeRole(role_id):
    return Role(role_id)
