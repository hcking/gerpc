import random

from client import Client, getRoleId

from config import configure
import gevent

address = configure['address']

ClientList = []


def createClient(no):
    for _ in range(no):
        c = Client(address)
        c.connect()
        ClientList.append(c)


def close():
    for c in ClientList:
        c.close()


def doWork():
    for c in ClientList:
        gevent.spawn(doit, c)
    return


def doit(c):
    while True:
        gevent.sleep(random.random())
        role_id = getRoleId()
        c.req1(role_id)
        c.req2()
        c.req2()
        c.req3()
        # break


def main():
    createClient(100)
    doWork()
    wait()
    close()


def wait():
    while True:
        try:
            gevent.sleep(1)
        except (KeyboardInterrupt, SystemExit):
            return


if __name__ == '__main__':
    main()
