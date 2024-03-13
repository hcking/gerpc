# coding=utf8

import os.path
import pandas as pd

from data import stcard

absPathFile = os.path.abspath(__file__)
absPath = os.path.dirname(absPathFile)

ExcelMap = {
    '玩家信息表.xlsx': {
        stcard.TableStConst,
        stcard.TableStGold77Bonus,
        stcard.TableStAttributeIndex,
    },
}


def getExcelPath(xlsxFile):
    res = os.path.join(absPath, 'config', xlsxFile)
    return res


def getCsvPath(table):
    sheetName = table.descriptor.tbl
    csvName = sheetName + '.csv'
    res = os.path.join(absPath, 'table', csvName)
    return res


def Excel2Csv():
    for xlsxFile, tableSet in ExcelMap.items():
        excelFile = getExcelPath(xlsxFile)
        sheetNames = [table.descriptor.tbl for table in tableSet]
        df = pd.read_excel(
            excelFile,
            sheet_name=sheetNames,
        )
        a = df
        for table in tableSet:
            csvFile = getCsvPath(table)
            sheetName = table.descriptor.tbl
            # df[sheetName].to_csv(csvFile, index=False)
    return


def main():
    # Excel2Csv()
    print(absPath)
    return


if __name__ == '__main__':
    main()
