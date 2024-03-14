# coding=utf8
import gevent
import traceback


class Timer:
    def __init__(self, fn, hour, minute, sec):
        self.fn = fn
        self.hour = hour
        self.minute = minute
        self.sec = sec
        self.key = (self.hour, self.minute, self.sec)

    def __str__(self):
        return "<{} {} {}>".format(self.__class__.__name__, self.fn, self.key)

    def __repr__(self):
        return self.__str__()

    def run(self):
        res = None
        try:
            res = self.fn()
        except Exception as ex:
            print('Timer run error', ex, Timer, traceback.format_exc())
        return res


class TimerMgr:
    _g_task = None
    _taskList = []
    _index = 0

    def __new__(cls, *args, **kwargs):
        raise NotImplemented

    @classmethod
    def start(cls):
        if not cls._g_task:
            cls._g_task = gevent.spawn(cls._run)
        return

    @classmethod
    def kill(cls):
        if cls._g_task:
            cls._g_task.kill()
        cls._g_task = None
        return

    @classmethod
    def getNowTask(cls):
        return

    @classmethod
    def next(cls):
        return

    @classmethod
    def register(cls, fn, hour, minute, sec):
        task = Timer(fn, hour, minute, sec)
        cls._taskList.append(task)
        cls._taskList.sort(key=lambda x: x.key)
        print(cls._taskList)
        return

    @classmethod
    def _run(cls):
        while True:
            print('_run')
            gevent.sleep(1)

    @classmethod
    def _next(cls):
        return

    @classmethod
    def restart(cls):
        cls.kill()
        cls.start()
        return


def refreshAtSomeTime1():
    print('refreshAtSomeTime1 begin')
    gevent.sleep(3)
    print('refreshAtSomeTime1 end')
    return


def refreshAtSomeTime2():
    print('refreshAtSomeTime2 begin')
    gevent.sleep(3)
    print('refreshAtSomeTime2 end')
    return


def refreshAtSomeTime3():
    print('refreshAtSomeTime3 begin')
    gevent.sleep(3)
    print('refreshAtSomeTime3 end')
    return


def registerAll():
    TimerMgr.register(refreshAtSomeTime3, 11, 30, 0)
    TimerMgr.register(refreshAtSomeTime2, 0, 30, 0)
    TimerMgr.register(refreshAtSomeTime1, 0, 0, 0)


def wait():
    try:
        while True:
            gevent.sleep(5)
    except (KeyboardInterrupt, SystemExit, Exception):
        pass
    return


def main():
    registerAll()

    TimerMgr.start()
    # wait()
    TimerMgr.kill()


if __name__ == '__main__':
    main()
