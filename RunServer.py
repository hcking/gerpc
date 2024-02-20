# coding=utf-8
import traceback

from config import configure
from server.server import GameServer
from util.log import log


def main():
    address = configure['address']
    gs = GameServer(address, backdoor=False)
    gs.start()
    log.warning("SystemStart on %s", address)
    print("SystemStart on %s", address)
    try:
        gs.serve_forever()
    except (KeyboardInterrupt, SystemExit):
        pass
    except Exception as ex:
        log.error("SystemStart error %s,%s", ex, traceback.format_exc())

    log.warning("SystemExit on %s", address)
    print("SystemExit on %s", address)
    return


if __name__ == '__main__':
    main()
