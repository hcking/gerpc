# coding=utf8

import os.path
import pandas as pd

from util.fn import getSrcPath

cachePath = os.path.join(getSrcPath(), '.csv_cache')

if not os.path.exists(cachePath):
    os.mkdir(cachePath)


def getExcelPath(card):
    res = os.path.join(getSrcPath(), 'config', card.descriptor.name)
    return res


def getCsvPath(card):
    sheetName = card.descriptor.tbl
    csvName = sheetName + '.csv'
    res = os.path.join(getSrcPath(), 'table', csvName)
    return res


def getCachePath(card):
    sheetName = card.descriptor.tbl
    cacheName = sheetName + '.cache'
    res = os.path.join(cachePath, cacheName)
    return res


def getDefineSourcePath(card):
    sourceFile = card.source.__file__
    return sourceFile


def getUseCols(card):
    cols = []
    for field in card.descriptor.fieldList:
        if field.colName in cols:
            raise AttributeError("getUseCols repeat!!!", card, field, field.colName)
        cols.append(field.colName)
    res = ','.join(cols)
    return res


def checkNeedConvertCsv(card):
    excelFile = getExcelPath(card)
    csvFile = getCsvPath(card)

    if not os.path.exists(excelFile):
        raise Exception("file not found", excelFile)

    if not os.path.exists(csvFile):
        return True

    # table update
    first_line = pd.read_csv(csvFile, nrows=1)
    _len = len(list(first_line))
    if _len != len(card.descriptor.fieldList):
        return True

    # diff time
    excelTime = os.path.getmtime(excelFile)
    csvTime = os.path.getmtime(csvFile)
    if excelTime > csvTime:
        return True

    return False


def excel2csv(card):
    need = checkNeedConvertCsv(card)
    if not need:
        return

    excelFile = getExcelPath(card)
    csvFile = getCsvPath(card)
    useCols = getUseCols(card)
    df = pd.read_excel(excelFile, sheet_name=card.descriptor.tbl, usecols=useCols)
    df.to_csv(csvFile, encoding='utf-8', index=False)

    print('excel2csv', excelFile, csvFile)
    return


def csv2cache(card):
    need = checkNeedConvertCache(card)
    if not need:
        return

    csvFile = getCsvPath(card)
    cacheFile = getCachePath(card)

    skipRowNo = 2
    df = pd.read_csv(csvFile, encoding='utf-8', skiprows=skipRowNo, header=None)
    df.to_pickle(cacheFile)
    print('csv2cache', csvFile, cacheFile)
    return


def checkNeedConvertCache(card):
    csvFile = getCsvPath(card)
    cacheFile = getCachePath(card)
    sourceFile = getDefineSourcePath(card)

    if not os.path.exists(csvFile):
        raise Exception("checkNeedConvertCache csvFile not found", csvFile)

    if not os.path.exists(sourceFile):
        raise Exception("checkNeedConvertCache sourceFile not found", sourceFile)

    if not os.path.exists(cacheFile):
        return True

    csvTime = os.path.getmtime(csvFile)
    cacheTime = os.path.getmtime(cacheFile)
    defTime = os.path.getmtime(sourceFile)

    if defTime > cacheTime:
        return True

    if csvTime > cacheTime:
        return True

    return False


def loadFromCache(card):
    updateCache(card)
    cacheFile = getCachePath(card)
    res = pd.read_pickle(cacheFile)
    return res.iterrows()


def loadCsvData(card):
    from persist.loader import convertMap
    data = loadFromCache(card)
    res = []
    for index, row in data:
        line = tuple(row)
        newLine = []
        for no, val in enumerate(line):
            field = card.descriptor.fieldList[no]
            converter = convertMap[field.default]
            try:
                newLine.append(converter(val))
            except Exception as ex:
                raise Exception('loadCsvData', ex, card, field, line, index)

        res.append(newLine)
    return res


def updateCache(card):
    excel2csv(card)
    csv2cache(card)
    return
