# coding=utf8

class Context:
    __slots__ = [
        'socket',
        'role_id',
        'channel',
        'address',
        'no',
        'sid',
    ]

    def __init__(self):
        self.socket = None
        self.role_id = 0
        self.channel = None
        self.address = None
        self.no = 0
        self.sid = 0


def getContext(socket, address):
    context = Context()
    context.socket = socket
    context.address = address
    return context
