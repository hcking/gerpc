# coding=utf8

import os.path
import pandas as pd

from util.fn import getSrcPath


def getExcelPath(xlsxFile):
    res = os.path.join(getSrcPath(), 'config', xlsxFile)
    return res


def getCsvPath(table):
    sheetName = table.descriptor.tbl
    csvName = sheetName + '.csv'
    res = os.path.join(getSrcPath(), 'table', csvName)
    return res


def excel2Csv(table):
    excelFile = getExcelPath(table.descriptor.name)
    csvFile = getCsvPath(table)
    df = pd.read_excel(
        excelFile,
        skiprows=10,
        header=None,
        sheet_name=table.descriptor.tbl,
    )
    _ = df
    return
