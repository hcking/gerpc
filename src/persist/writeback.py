# coding=utf8


WriteBackList = []


class WriteBack:
    def __init__(self, cls):
        self.cls = cls
        self.record_delete = set()
        self.record_update = set()
        self.record_insert = set()
        self.record_pk = set()
        self.record_pk_delete = set()

        if self.cls.descriptor.writeable and self not in WriteBackList:
            WriteBackList.append(self)
