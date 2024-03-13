# coding=utf8
import os.path

absPathFile = os.path.abspath(__file__)
srcPath = os.path.dirname(os.path.dirname(absPathFile))


def getSrcPath():
    return srcPath
