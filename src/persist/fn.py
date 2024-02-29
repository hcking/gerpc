# coding=utf8


from datetime import datetime


def getIndex(data, cols):
    return (data[name] for name in cols)


def getPrimaryValue(data, descriptor):
    return tuple(data[i] for i in descriptor.primaryIndex.cols)


def escape(v):
    if v is None:
        return 'null'
    if isinstance(v, str):
        if "'" in v:
            return '"%s"' % v
        return "'%s'" % v
    if isinstance(v, datetime):
        return "'%s'" % v.strftime('%Y-%m-%d %H:%M:%S')
    return '%s' % v
