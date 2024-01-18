# coding=utf8


class Context:
    __slots__ = [
        'socket',
        'role_id',
        'channel',
        'address',
        'no',
        'sid',
        'req',
        'resp',
    ]

    def __init__(self):
        self.socket = None
        self.role_id = 0
        self.channel = None
        self.address = None
        self.no = 0
        self.sid = 0
        self.req = None
        self.resp = None

    def __str__(self):
        _str = f'Context,{self.role_id},{self.no},{self.sid}'
        return _str

    def __repr__(self):
        return self.__str__()


def getContext(socket, address):
    context = Context()
    context.socket = socket
    context.address = address
    return context
