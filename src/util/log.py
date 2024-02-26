# conding=utf8
import os.path

from configure import Configure
import logging
from logging.handlers import TimedRotatingFileHandler

logFormat = '%(asctime)s %(filename)s %(levelname)s:%(message)s'

# 创建日志记录器
logger = logging.getLogger(__name__)
logger.setLevel(Configure.logLevel)
d = os.path.dirname(Configure.logPath)
fullPath = os.path.abspath(d)
if not os.path.exists(fullPath):
    os.makedirs(fullPath)

handler = TimedRotatingFileHandler(Configure.logPath, when='midnight', interval=1, backupCount=30)
handler.setLevel(Configure.logLevel)

# 设置日志记录格式
formatter = logging.Formatter(logFormat)
handler.setFormatter(formatter)

# 将 handler 添加到日志记录器
logger.addHandler(handler)

getLogger = logging.getLogger
