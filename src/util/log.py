# conding=utf8

from config import configure
import logging
from logging.handlers import TimedRotatingFileHandler

logFormat = '%(asctime)s %(filename)s %(levelname)s:%(message)s'

# 创建日志记录器
logger = logging.getLogger(__name__)
logger.setLevel(configure['logLevel'])

handler = TimedRotatingFileHandler(configure['logPath'], when='midnight', interval=1, backupCount=30)
handler.setLevel(configure['logLevel'])

# 设置日志记录格式
formatter = logging.Formatter(logFormat)
handler.setFormatter(formatter)

# 将 handler 添加到日志记录器
logger.addHandler(handler)

log = logger
