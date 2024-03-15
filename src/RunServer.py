# coding=utf-8


if True:
    from gevent import monkey

    monkey.patch_all()

import traceback
import signal
from gevent import signal_handler

from configure import Configure
from server.server import GameServer
from util import logger, timer
from cache import constant
from persist import writeback

log = logger.getLogger(name='')

_isExit = False


def SIGINTHandler(*args):
    log.info("SIGINTHandler %s", args)
    systemExit()
    return


def registerSignal():
    # signal.signal(signal.SIGINT, SIGINTHandler)
    signal_handler(signal.SIGINT, SIGINTHandler)
    return


def systemExit():
    global _isExit
    if _isExit:
        return

    writeback.stopTimerWriteBack()
    timer.Timer.kill()

    constant.gameServer.close()

    log.warning("SystemExit on %s", Configure.address)
    print("SystemExit on %s", Configure.address)
    _isExit = True
    return


def main():
    registerSignal()

    constant.gameServer = GameServer(Configure.address, backdoor=Configure.backdoor)
    constant.gameServer.start()

    log.warning("SystemStart on %s", Configure.address)
    print("SystemStart on %s", Configure.address)

    timer.init()

    try:
        constant.gameServer.serve_forever(stop_timeout=3)
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
