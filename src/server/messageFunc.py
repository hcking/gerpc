# coding=utf-8
import struct

from server.errors import ProtocolError
from util.logger import getLogger
from proto.pn import ruleMap, getProtocolReq, getProtocolResp

log = getLogger(__name__)

PackageMaxLen = 65535


class MessageFunc:
    def __init__(self, hdrFmt='<IIL', isClient=False):
        self.isClient = isClient  # 指定读取消息时的结构 创建对象是req 还是 resp
        self.hdrFmt = hdrFmt
        self.hdrStruct = struct.Struct(hdrFmt)
        self.hdrSize = self.hdrStruct.size
        if self.hdrSize < 8:
            raise ProtocolError('Header format error', self.hdrSize)

    def readMsg(self, socket):
        hdr = socket.recv(self.hdrSize)
        _len = len(hdr)

        if _len == 0:  # socket 正常关闭
            raise ProtocolError(0, 'Incomplete header 0')

        if _len != self.hdrSize:
            log.error('Incomplete header. %s', _len)
            raise ProtocolError(1, 'readMsg Incomplete header', _len)

        data = self.hdrStruct.unpack(hdr)
        no, length, sid = data

        if no not in ruleMap:
            raise ProtocolError(2, "not protocolNo", no)

        if length:
            if length >= PackageMaxLen:
                raise ProtocolError(3, 'readMsg Message too large.', no, length)

            data = socket.recv(length)

            if len(data) != length:
                log.error('Incomplete data length error %s, %s', len(data), length)
                raise ProtocolError(4, 'readMsg Incomplete data.')

            if self.isClient:
                req = getProtocolResp(no)
            else:
                req = getProtocolReq(no)

            if req is not None:
                req.MergeFromString(data)
        else:
            req = None
        return no, req, sid

    def writeMsg(self, socket, no, resp, sid):
        if not resp:
            data = bytes()
        elif hasattr(resp, 'SerializeToString'):
            data = resp.SerializeToString()
        else:
            raise ValueError('data error', resp, type(resp))

        hdr = self.hdrStruct.pack(no, len(data), sid)
        socket.send(hdr)
        socket.send(data)
        return
