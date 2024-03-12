# coding=utf8

from client import Client
from configure import Configure
from proto.pn import getProtocolReq


class MyClient(Client):

    def req1(self, role_id):
        no = 1
        req = getProtocolReq(no)
        req.role_id = role_id
        req.account = str(req.role_id) + '@' + str(req.role_id)
        resp = self.sendMsgAndWait(no, req)
        return resp

    def req2(self):
        no = 2
        req = getProtocolReq(no)
        resp = self.sendMsgAndWait(no, req)
        return resp

    def req3(self):
        no = 3
        req = getProtocolReq(no)
        req['name'] = "name1"
        req['req_id'] = 999
        resp = self.sendMsgAndWait(no, req)
        return resp


def main():
    client = MyClient(Configure.address)
    client.connect()

    client.req1(10000)
    client.req2()
    client.req3()

    client.close()
    return


if __name__ == '__main__':
    main()
