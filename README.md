<h3 align="center">gserver</h3>


<p align="center">
    Card GameServer from gevent
    卡牌游戏服务器框架 
</p>

---

## 目录说明

- **src/server**: GameServer服务器类 接收发送消息规则
- **src/persist**: 数据库读写数据 orm持久化
- **src/handler**: 注册处理定义协议的函数
- **src/proto**: 生成目录

## 组件说明

- **GameServer**: 基于gevent StreamServer 开启协程通信
- **protobuf**: 支持
- **json**: 支持

## 使用说明

```commandline
python make.py # 编译生成 protobuf 文件 自定义协议i文件
cd src; python RunServer.py # 启动游戏服务器 
```
