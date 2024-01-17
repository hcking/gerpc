# coding=utf-8
import random
import socket
from config import configure
from server.messageFunc import MessageFunc
from pb.pn import getProtocolReq


def getRoleId():
    return random.randint(2 ** 16, 2 ** 32)


class Client:
    def __init__(self, address):
        self.address = address
        self.sid = random.randint(1, 999)
        self.messageFunc = MessageFunc(readIndex=1)
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connect(self):
        self.socket.connect(self.address)

    def getSid(self):
        self.sid += 1
        return self.sid

    def reqLogin(self, role_id):
        no = 1
        req = getProtocolReq(no)
        req.role_id = role_id
        req.account = str(req.role_id) + '@' + str(req.role_id)
        resp = self.requestAndWait(no, req)
        return resp

    def reqRoleInfo(self):
        no = 2
        req = getProtocolReq(no)
        resp = self.requestAndWait(no, req)
        return resp

    def reqDictInfo(self):
        no = 3
        req = getProtocolReq(3)
        req['name'] = "tzz"
        req['req_id'] = 999
        resp = self.requestAndWait(no, req)
        return resp

    def requestAndWait(self, no, req):
        sid = self.getSid()
        print('requestAndWait send', no, sid)
        self.messageFunc.writeMsg(self.socket, no, req, sid)
        _, resp, sid = self.messageFunc.readMsg(self.socket)
        # print('requestAndWait recv', no, sid, type(resp))
        return resp

    def close(self):
        self.socket.close()


def main():
    address = configure['address']
    c = Client(address)
    c.connect()

    role_id = getRoleId()
    c.reqLogin(role_id)
    c.reqRoleInfo()
    # c.reqRoleInfo()
    # c.reqRoleInfo()
    c.reqDictInfo()

    c.close()
    return


if __name__ == '__main__':
    main()
