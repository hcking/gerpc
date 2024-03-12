# coding=utf8
if 1:
    from gevent import monkey

    monkey.patch_all()

from gevent import socket
from server.messageFunc import MessageFunc


class Client:
    def __init__(self, address, timeout=2):
        self._address = address
        self._messageFunc = MessageFunc(isClient=True)
        self._sid = 0
        self._socket = None
        self._timeout = timeout

    def getSid(self):
        self._sid += 1
        return self._sid

    def connect(self):
        self._socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._socket.connect(self._address)
        self._socket.settimeout(self._timeout)
        return

    def close(self):
        if self._socket:
            self._socket.shutdown(socket.SHUT_RDWR)
            self._socket.close()
        self._socket = None
        return

    def sendMsg(self, no, req, sid=0):
        if sid <= 0:
            sid = self.getSid()
        print('sendMsg', no, sid, req)
        self._messageFunc.writeMsg(self._socket, no, req, sid)
        return

    def sendMsgAndWait(self, no, req):
        sid = self.getSid()
        self.sendMsg(no, req, sid)
        no, resp, sid = self._messageFunc.readMsg(self._socket)
        print('sendMsgAndWait resp', no, sid, resp)
        return resp
