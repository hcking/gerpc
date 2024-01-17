<h3 align="center">gerpc</h3>


<p align="center">
    游戏服务器框架 
</p>

---

## 组件说明

- **GameServer**: 基于gevent StreamServer 开启协程通信server
- **protobuf**: 支持
- **json**: 支持

## 使用说明

```commandline
cd pb; python genpn.py # 编译生成 protobuf 文件 自定义协议i文件

python RunServer.py # 启动游戏服务器

python client.py # 启动客户端 向服务器发送请求协议
 
```