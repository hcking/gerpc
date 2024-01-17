# coding=utf8
import random
import time

import pb
from pb.pn import (
    registerProtocol
)

from handler.fn import (
    GetRoleById,
    Succ,
    Fail,
    GetRoleByContext,
)

from log.log import log


@registerProtocol(pb.pn.protocLogin)
def protocLoginHandler(context, req, resp):
    log.debug("HandlerLogin req %s", req)
    role = GetRoleById(req.role_id)
    if not role:
        return Fail(resp, 0)
    context.role_id = role.role_id
    role.account = req.account
    resp.finalAtk = role.age
    log.debug("HandlerLogin resp %s", resp)
    return Succ(resp)


@registerProtocol(pb.pn.protocRoleInfo)
def protocLoginHandler(context, req, resp):
    log.debug("handlerRoleInfo req %s", req)
    # time.sleep(random.random())

    role = GetRoleByContext(context)
    if not role:
        return Fail(resp.res, 0)
    fillRoleInfo(role, resp.role)

    log.debug("handlerRoleInfo resp %s", resp)
    return Succ(resp.res)


def fillRoleInfo(role, resp):
    resp.role_id = role.role_id
    resp.account = role.account
    resp.name = role.name
    resp.age = role.age
    return
