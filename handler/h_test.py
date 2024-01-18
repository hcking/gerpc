from pb.pn import (
    registerProtocol,
    protocDictTest,
)


@registerProtocol(protocDictTest)
def protocDictTestHandler(context):
    context.resp['ok'] = True
    context.resp['code'] = 10
    context.resp['resp_id'] = context.req.get('req_id', 0)
    context.resp['name'] = context.req.get('name', 'foo')
    context.resp['sid'] = context.sid
    return
