# coding=utf8

defaultInt = 0
defaultStr = ""
defaultFloat = 0.1


def convertFloat(val):
    return float(round(val, 2))


def convertInt(val):
    return int(val)


def convertStr(val):
    return str(val)


convertMap = {
    defaultFloat: convertFloat,
    defaultInt: convertInt,
    defaultStr: convertStr,
}
