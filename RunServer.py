# coding=utf-8
import traceback

from gevent.monkey import patch_all
from config import configure
from server.server import GameServer
from log.log import log


def main():
    patch_all()

    address = configure['address']
    gs = GameServer(address)
    gs.start()
    log.info("SystemStart on %s", address)
    try:
        gs.serve_forever()
    except (KeyboardInterrupt, SystemExit):
        pass
    except Exception as ex:
        log.error("SystemStart error %s,%s", ex, traceback.format_exc())

    log.info("SystemExit on %s", address)
    return


if __name__ == '__main__':
    main()
