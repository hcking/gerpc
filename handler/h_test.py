import pb
from pb.pn import (
    registerProtocol
)


@registerProtocol(pb.pn.protocDictTest)
def protocDictTestHandler(context, req, resp):
    # log.info("protocDictTestHandler %s", req)
    resp['ok'] = True
    resp['code'] = 10
    resp['resp_id'] = req.get('req_id')
    resp['name'] = 'abcd'
    resp['sid'] = context.sid
    return
