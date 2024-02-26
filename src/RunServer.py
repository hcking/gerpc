# coding=utf-8


import traceback
import signal

from configure import Configure
from server.server import GameServer
from util.log import log
from cache import constant

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
    constant.gameServer.close()
    log.warning("SystemExit on %s", Configure.address)
    print("SystemExit on %s", Configure.address)
    _isExit = True
    return


def main():
    registerSignal()
    gs = GameServer(Configure.address, backdoor=Configure.backdoor)
    constant.gameServer = gs
    gs.start()
    log.warning("SystemStart on %s", Configure.address)
    print("SystemStart on %s", Configure.address)
    try:
        gs.serve_forever()
    except (KeyboardInterrupt, SystemExit) as err:
        print(err)
    except Exception as ex:
        print(traceback.format_exc())
        log.error("RunServer error %s,%s", ex, traceback.format_exc())
    finally:
        systemExit()
    return


if __name__ == '__main__':
    main()
