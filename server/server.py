"""
gevent GameServer
"""

import time
import os
import socket
import traceback
import gevent
from gevent.server import StreamServer
from gevent.backdoor import BackdoorServer
from gevent.queue import Queue

from server.messageFunc import MessageFunc
from server.context import getContext
from server.errors import ProtocolError
from pb.pn import ruleMap, getProtocFunc, getProtocolResp

from util.log import log


class GameServer(StreamServer):
    def __init__(self, address, backdoor=True):
        self.address = address
        self.ip, self.port = address
        self.backDoorPort = self.port + 1

        self.messageFunc = MessageFunc()
        self.sid = 1
        self.backdoor = backdoor

        super().__init__(address, self.handlerConn)

    def handlerConn(self, conn, address):
        log.debug("handlerConn New  From %s", address)
        context = getContext(conn, address)
        self.handleContext(context)
        self.clean(context)

        log.debug("handlerConn Close  From %s", address)
        return

    def startBackDoor(self):
        if not self.backdoor:
            return
        address = ('127.0.0.1', self.backDoorPort)
        banner = "backdoor on {}".format(self.backDoorPort)
        bds = BackdoorServer(address, locals(), banner)
        bds.start()
        log.warning("startBackDoor on %s", address)
        return

    def start(self):
        loadHandlers()
        super().start()
        self.startBackDoor()
        return

    def handleContext(self, context):
        context.channel = Queue()

        def sendTask():
            for _no, _resp, _sid in context.channel:
                if _resp:
                    self.messageFunc.writeMsg(context.socket, _no, _resp, sid)
            return

        w = gevent.spawn(sendTask)
        isRunning = True
        try:
            while isRunning:
                no, req, sid = self.messageFunc.readMsg(context.socket)
                isRunning = onMessage(context, no, req, sid)
        except ProtocolError as ex:
            errCode = ex.args[0]
            if errCode != 0:
                log.error('handleContext ProtocolError %s,%s', ex, errCode)
        except Exception as ex:
            log.error("handleContext error %s,%s", ex, traceback.format_exc())
        finally:
            w.kill()
            del w
        return

    def clean(self, context):
        context.socket.shutdown(socket.SHUT_RDWR)
        context.socket.close()
        return


def loadHandlers():
    import handler
    fold = os.path.dirname(handler.__file__)
    handlers = []
    for i in os.listdir(fold):
        if i.startswith('__') or os.path.isdir(i):
            continue
        handlers.append(os.path.basename(os.path.splitext(i)[0]))
    if handlers:
        dummy = __import__(handler.__name__, globals(), locals(), handlers)
    checkRules()


def checkRules():
    for no, rule in ruleMap.items():
        if not getProtocFunc(no):
            log.error('No handler for %s,%s', no, rule)
    return


def onMessage(context, no, req, sid):
    try:
        context.no = no
        context.sid = sid
        resp = getProtocolResp(no)
        fn = getProtocFunc(no)
        begin_time = time.time()
        fn(context, req, resp)
        use = time.time() - begin_time
        log.info("onMessage,%s,%s,%s,%s", no, context.role_id, sid, use)
    except Exception as ex:
        log.error("onMessage error %s,%s,%s,%s", no, sid, ex, traceback.format_exc())
        return False
    if resp:
        context.channel.put((no, resp, sid))
    return True
