# coding=utf-8


import sys
import traceback
import signal

from configure import Configure
from server.server import GameServer
from util.log import log
from cache.constant import Constant

_isExit = False


def SIGINTHandler(sig, frame):
    _ = frame
    log.info("SIGINTHandler %s", sig)
    systemExit()
    return


def registerSignal():
    signal.signal(signal.SIGINT, SIGINTHandler)


def systemExit():
    global _isExit
    if _isExit:
        return
    Constant.gameServer.close()
    log.warning("SystemExit on %s", Configure.address)
    print("SystemExit on %s", Configure.address)
    _isExit = True
    return


def main():
    registerSignal()
    Constant.gameServer = GameServer(Configure.address, backdoor=Configure.backdoor)
    Constant.gameServer.start()
    log.warning("SystemStart on %s", Configure.address)
    print("SystemStart on %s", Configure.address)
    try:
        Constant.gameServer.serve_forever()
    except (KeyboardInterrupt, SystemExit):
        pass
    except Exception as ex:
        log.error("RunServer error %s,%s", ex, traceback.format_exc())
    finally:
        systemExit()
    return


if __name__ == '__main__':
    main()
