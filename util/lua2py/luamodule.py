# coding=utf-8
import objprint
from luaparser import ast


class LuaBase(object):
    content = ""
    obj = None
    tabCount = 0
    lf = '\n'

    def __str__(self):
        s = "LuaBase<{}>".format(self.obj)
        return s

    def __repr__(self):
        return self.__str__()

    def begin(self):
        return

    def mid(self):
        return

    def end(self):
        return

    def convertComments(self):
        if not self.obj:
            return
        for comment in self.obj.comments:
            c = LuaComment(comment)
            tab = self.getTab()
            self.content += tab + c.content
        return

    def write(self):
        return

    def getTab(self):
        tab = "    " * self.tabCount
        return tab

    def addTabCount(self):
        self.tabCount += 1

    def redTabCount(self):
        self.tabCount -= 1


class LuaTable(LuaBase):

    def __init__(self, table, tabCount=0):
        self.obj = table
        self.tabCount = tabCount

        self.begin()
        for field in self.obj.fields:
            f = LuaField(field, tabCount=self.tabCount)
            self.content += f.content + self.lf
        self.end()

    def begin(self):
        self.content = '{' + self.lf
        self.addTabCount()

    def end(self):
        self.redTabCount()
        tab = self.getTab()
        self.content += tab + '}' + self.lf


class LuaAssign(LuaBase):

    def __init__(self, assign, tabCount=0):
        self.obj = assign
        self.tabCount = tabCount

        self.convertComments()
        targetList = []
        valueList = []
        _lenTargets = len(self.obj.targets)
        _lenValues = len(self.obj.values)
        if _lenTargets != _lenValues:
            raise ValueError(self, _lenTargets, _lenValues)

        for target in self.obj.targets:
            cls = getConvertClass(target)
            obj = cls(target, tabCount=self.tabCount)
            targetList.append(obj.content)

        for value in self.obj.values:
            cls = getConvertClass(value)
            obj = cls(value, tabCount=self.tabCount)
            valueList.append(obj.content)

        if _lenTargets == 1:
            s = ','.join(targetList) + ' = ' + valueList[0]
        else:
            s = ""
            pass

        tab = self.getTab()
        res = self.content + tab + s + self.lf
        self.content = res


class LuaFunction(LuaBase):

    def __init__(self, function, tabCount=0):
        self.obj = function
        self.tabCount = tabCount

        tab = self.getTab()
        self.begin()
        name = LuaName(self.obj.name).content
        argNameList = [LuaName(obj).content for obj in self.obj.args]
        define = tab + "def {name}({argStr}):".format(
            name=name,
            argStr=','.join(argNameList)
        ) + self.lf
        self.content = define

        # body
        obj = LuaBlock(self.obj.body, tabCount=self.tabCount)
        self.content += obj.content

        self.end()

    def begin(self):
        self.addTabCount()

    def end(self):
        self.redTabCount()


class LuaName(LuaBase):

    def __init__(self, name, tabCount=0):
        self.obj = name
        self.tabCount = tabCount

        self.content = self.obj.id


class LuaNumber(LuaBase):

    def __init__(self, number, tabCount=0):
        self.obj = number
        self.tabCount = tabCount

        self.content = str(self.obj.n)


class LuaUMinusOp(LuaBase):

    def __init__(self, op, tabCount=0):
        self.obj = op
        self.tabCount = tabCount

        cls = getConvertClass(self.obj.operand)
        obj = cls(self.obj.operand)
        self.content = obj.content


class LuaComment(LuaBase):

    def __init__(self, comment):
        self.obj = comment
        self.content = '#' + self.obj.s + self.lf


class LuaString(LuaBase):

    def __init__(self, string):
        self.string = string


class LuaLocalFunction(LuaBase):

    def __init__(self, func, tabCount=0):
        self.obj = func
        self.tabCount = tabCount


class LuaLocalAssign(LuaBase):

    def __init__(self, assign):
        self.obj = assign


class LuaBlock(LuaBase):

    def __init__(self, block, tabCount=0):
        self.obj = block
        self.tabCount = tabCount

        self.convertComments()
        for body in self.obj.body:
            cls = getConvertClass(body)
            newObj = cls(body, tabCount=self.tabCount)
            self.content += newObj.content


class LuaField(LuaBase):

    def __init__(self, field, tabCount=0):
        self.obj = field
        self.tabCount = tabCount

        cls = getConvertClass(self.obj.key)
        obk = cls(self.obj.key, tabCount=self.tabCount)

        cls = getConvertClass(self.obj.value)
        obv = cls(self.obj.value, tabCount=self.tabCount)

        tab = self.getTab()
        res = tab + obk.content + ' = ' + obv.content
        self.content = res
        pass


class LuaChunk(LuaBase):

    def __init__(self, chunk):
        self.obj = chunk

        self.convertComments()
        block = self.obj.body
        b = LuaBlock(block, tabCount=0)
        self.content = b.content


class LuaCall(LuaBase):

    def __init__(self, call, tabCount=0):
        self.obj = call
        self.tabCount = tabCount

        argList = []
        for arg in self.obj.args:
            cls = getConvertClass(arg)
            obj = cls(arg)
            argList.append(obj.content)
        name = LuaName(self.obj.func).content
        tab = self.getTab()
        define = tab + "{}({})\n".format(name, ','.join(argList))
        self.content = define


class LuaConcat(LuaBase):
    def __init__(self, concat, tabCount=0):
        self.obj = concat
        self.tabCount = tabCount

        cls = getConvertClass(self.obj.left)
        obj = cls(self.obj.left)
        leftS = obj.content
        rightS = LuaName(self.obj.right).content
        self.content = leftS + ',' + rightS


ConvertMap = {
    ast.Table: LuaTable,
    ast.Assign: LuaAssign,
    ast.Function: LuaFunction,
    ast.Field: LuaField,
    ast.Name: LuaName,
    ast.Number: LuaNumber,
    ast.UMinusOp: LuaUMinusOp,
    ast.Comments: LuaComment,
    ast.String: LuaString,
    ast.Block: LuaBlock,
    ast.Chunk: LuaChunk,
    ast.LocalFunction: LuaFunction,
    ast.LocalAssign: LuaLocalAssign,
    ast.Call: LuaCall,
    ast.Concat: LuaConcat,

}


def getConvertClass(obj):
    t = type(obj)
    if t in ConvertMap:
        return ConvertMap[t]
    raise TypeError("getConvertClass not type", obj, t)
