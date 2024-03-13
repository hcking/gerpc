# coding=utf8

import os.path
import pandas as pd

from util.fn import getSrcPath


def getExcelPath(card):
    res = os.path.join(getSrcPath(), 'config', card.descriptor.name)
    return res


def getCsvPath(card):
    sheetName = card.descriptor.tbl
    csvName = sheetName + '.csv'
    res = os.path.join(getSrcPath(), 'table', csvName)
    return res


def getUseCols(card):
    cols = []
    for field in card.descriptor.fieldList:
        if field.colName in cols:
            raise AttributeError("getUseCols repeat!!!", card, field, field.colName)
        cols.append(field.colName)
    res = ','.join(cols)
    return res


def checkNeedConvert(card):
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
    isNeed = checkNeedConvert(card)
    if not isNeed:
        return

    excelFile = getExcelPath(card)
    csvFile = getCsvPath(card)
    useCols = getUseCols(card)
    df = pd.read_excel(excelFile, sheet_name=card.descriptor.tbl, usecols=useCols)
    df.to_csv(csvFile, encoding='utf-8', index=False)

    print('excel2csv', csvFile)
    return


def loadCsvData(card):
    excel2csv(card)

    res = []
    csvFile = getCsvPath(card)
    skipRowNo = 2
    df = pd.read_csv(csvFile, encoding='utf-8', skiprows=skipRowNo, header=None)
    for index, row in df.iterrows():
        line = tuple(row)
        res.append(line)
    return res
