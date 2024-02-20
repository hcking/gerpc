"""
gevent GameServer
"""
from gevent import monkey

if True:  # fuck pep8
    monkey.patch_all()

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
        log.info("handlerConn New From %s", address)
        context = getContext(conn, address)
        self.handleContext(context)
        log.info("handlerConn Close From %s, %s", address, context.role_id)
        cleanContext(context)
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
            for _ in context.channel:
                self.messageFunc.writeMsg(context.socket, context.no, context.resp, context.sid)
            return

        g_sendTask = gevent.spawn(sendTask)
        isRunning = True
        try:
            while isRunning:
                context.no, context.req, context.sid = self.messageFunc.readMsg(context.socket)
                isRunning = onMessage(context)
        except ProtocolError as ex:
            errCode = ex.args[0]
            if errCode != 0:
                log.error('handleContext ProtocolError %s,%s', ex, errCode)
        except Exception as ex:
            log.error("handleContext error %s,%s", ex, traceback.format_exc())
        finally:
            g_sendTask.kill()
        return


def cleanContext(context):
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


def onMessage(context):
    try:
        context.resp = getProtocolResp(context.no)
        fn = getProtocFunc(context.no)
        begin_time = time.time()
        fn(context)
        use = time.time() - begin_time
        log.info("onMessage,%s,%s", context, use)
    except Exception as ex:
        log.error("onMessage error %s,%s,%s", context, ex, traceback.format_exc())
        return False
    if context.resp:
        context.channel.put(1)
    return True
