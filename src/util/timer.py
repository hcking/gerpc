# coding=utf8
import gevent
import traceback
from datetime import datetime, timedelta


class Task:
    def __init__(self, fn, hour, minute, sec):
        self.fn = fn
        self.hour = hour
        self.minute = minute
        self.sec = sec
        self.key = (self.hour, self.minute, self.sec)

    def __str__(self):
        return "<{} {} {}>".format(self.__class__.__name__, self.key, self.fn)

    def __repr__(self):
        return self.__str__()

    def __eq__(self, other):
        assert isinstance(other, Task)
        return self.key == other.key

    def run(self):
        res = None
        try:
            res = self.fn()
        except Exception as ex:
            print('Timer run error', ex, Task, traceback.format_exc())
        return res


class Timer:
    _g_task = None
    _taskList = []
    _index = 0
    _job = None

    def __new__(cls, *args, **kwargs):
        raise NotImplemented

    @classmethod
    def _run(cls):
        while True:
            task = cls.getNowTask()
            timeGap = cls.getTaskWaitTime(task)
            now = int(datetime.now().timestamp())

            print('_run', now, timeGap, now + timeGap, task)
            cls._job = gevent.spawn_later(timeGap, task.run)
            cls._job.join()
            cls._next()

    @classmethod
    def start(cls):
        cls._refreshTask()
        if not cls._g_task:
            cls._g_task = gevent.spawn(cls._run)
        return

    @classmethod
    def kill(cls):
        if cls._g_task:
            cls._g_task.kill()
        if cls._job:
            cls._job.kill()
        cls._g_task = None
        return

    @classmethod
    def restart(cls):
        """
        if change machine time or mock time
        call: Timer.restart()  # refresh task.
        """
        cls.kill()
        cls.start()
        return

    @classmethod
    def _next(cls):
        cls._index += 1
        if cls._index >= len(cls._taskList):
            cls._index = 0
        return

    @classmethod
    def _refreshTask(cls):
        cls._index = 0
        key = cls.getNowKey()
        for index, task in enumerate(cls._taskList):
            if task.key > key:
                cls._index = index
                break
        return

    @classmethod
    def getNowTask(cls):
        task = cls._taskList[cls._index]
        return task

    @classmethod
    def registerTask(cls, fn, hour, minute):
        task = Task(fn, hour, minute, sec=0)
        if task in cls._taskList:
            raise Exception("repeat task", task)
        cls._taskList.append(task)
        cls._taskList.sort(key=lambda x: x.key)
        return

    @classmethod
    def getNowKey(cls):
        now = datetime.now()
        key = (now.hour, now.minute, now.second)
        return key

    @classmethod
    def getTaskWaitTime(cls, task):
        now = datetime.now()
        nowTimeStamp = int(now.timestamp())

        taskDay = now
        if task.key < cls.getNowKey():
            taskDay = now + timedelta(days=1)

        taskDay = taskDay.replace(
            hour=task.hour,
            minute=task.minute,
            second=task.sec,
            microsecond=0
        )

        taskTimeStamp = int(taskDay.timestamp())

        sec = taskTimeStamp - nowTimeStamp
        return sec


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


def init():
    registerAll()
    Timer.start()


def registerAll():
    Timer.registerTask(refreshAtSomeTime3, 13, 50)
    Timer.registerTask(refreshAtSomeTime2, 0, 30)
    Timer.registerTask(refreshAtSomeTime1, 0, 0)
