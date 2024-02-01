# coding=utf8

"""
翻译lua代码为python代码

"""

import os.path
import logging
import sys

from luaparser import ast
from luamodule import LuaChunk

logging.basicConfig(
    level=logging.ERROR,
    format="%(levelname)s:%(asctime)s:%(message)s",
    handlers=[
        logging.FileHandler('convert.log'),
        logging.StreamHandler(),
    ]
)

log = logging.getLogger(__name__)


class Lua2Python(object):
    def __init__(self, fileList):
        self.fileList = fileList


def luaFileName2pythonFileName(filename):
    basename = os.path.basename(filename)
    name = basename.split('.')[0]
    return name + '.py'


class LuaFile(object):
    def __init__(self, filename):
        self.filename = filename
        self.toFileName = luaFileName2pythonFileName(self.filename)
        self.stream = None

    def __str__(self):
        return "LuaFile<{}>".format(self.filename)

    def __repr__(self):
        return self.__str__()

    def read(self):
        with open(self.filename, encoding='utf8') as f:
            content = f.read()
        return content

    def initFile(self):
        # self.stream = open(self.toFileName, 'w')
        self.stream = sys.stdout
        return

    def close(self):
        if self.stream:
            self.stream.close()
        return

    def parse(self):
        self.initFile()
        content = self.read()
        chunk = ast.parse(content)
        print(chunk.body.to_json())
        # c = LuaChunk(chunk)
        # print(dir(c))
        # print(c.content)
        self.close()
        return


def main():
    sourceFile = 't.lua'
    luaFile = LuaFile(sourceFile)
    luaFile.parse()
    return


if __name__ == '__main__':
    main()
