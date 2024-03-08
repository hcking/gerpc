# coding=utf8

import shutil
import os
import sys

isWindows = sys.platform.startswith('win')

pythonExec = 'python'
protoFileList = ['xx.proto']
protoc = 'protoc'
toProtoDir = os.path.join('src', 'proto')

if isWindows:
    protoc = os.path.join('protobuf', 'protoc3')


def createFile(fp, s=""):
    with open(fp, 'w') as f:
        f.write(s)
    return


def doCommand(cmd):
    res = os.system(cmd)
    if res:
        raise ValueError(res)
    return


def makeProto():
    if not os.path.exists(toProtoDir):
        os.mkdir(toProtoDir)
    for protoFile in protoFileList:
        cmd = f'{protoc} -I protobuf --python_out={toProtoDir} {protoFile}'
        doCommand(cmd)

    createFile(os.path.join(toProtoDir, '__init__.py'))
    doCommand(f'cd protobuf && {pythonExec} gen.py')
    return


def clean():
    if os.path.exists(toProtoDir):
        shutil.rmtree(toProtoDir)
    return


def main():
    clean()
    makeProto()
    return


if __name__ == '__main__':
    main()
