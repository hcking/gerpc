<h3 align="center">gerpc</h3>


<p align="center">
    Card GameServer from gevent
    卡牌游戏服务器框架 
</p>

---

## 目录说明

- **handler**: 注册处理定义协议的函数
- **pb**: 自定义协议 生成protobuf文件
- **persist**: 数据库读写数据 orm持久化
- **timer**: 定时器
- **server**: GameServer服务器类 接收发送消息规则

## 组件说明

- **GameServer**: 基于gevent StreamServer 开启协程通信
- **protobuf**: 支持
- **json**: 支持

## 使用说明

```commandline
cd pb; python genpn.py # 编译生成 protobuf 文件 自定义协议i文件

python RunServer.py # 启动游戏服务器

python client.py # 启动客户端 向服务器发送请求协议
 
```
