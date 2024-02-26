# coding=utf8

from proto.pn import (
    registerProtocol,
    protocLogin,
    protocRoleInfo,
)

from handler.fn import (
    GetRoleById,
    Succ,
    Fail,
    GetRoleByContext,
)

from util.log import log


@registerProtocol(protocLogin)
def protocLoginHandler(context):
    log.debug("HandlerLogin req %s", context.req)
    role = GetRoleById(context.req.role_id)
    if not role:
        return Fail(context.resp, 0)
    context.role_id = role.role_id
    role.account = context.req.account
    context.resp.finalAtk = role.age
    log.debug("HandlerLogin resp %s", context.resp)
    return Succ(context.resp)


@registerProtocol(protocRoleInfo)
def protocLoginHandler(context):
    log.debug("handlerRoleInfo req %s", context.req)
    # time.sleep(random.random())

    role = GetRoleByContext(context)
    if not role:
        return Fail(context.resp.res, 0)
    fillRoleInfo(role, context.resp.role)

    log.debug("handlerRoleInfo resp %s", context.resp)
    return Succ(context.resp.res)


def fillRoleInfo(role, resp):
    resp.role_id = role.role_id
    resp.account = role.account
    resp.name = role.name
    resp.age = role.age
    return
