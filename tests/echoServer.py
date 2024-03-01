#!/usr/bin/env python

from gevent.server import StreamServer


# this handler will be run for each incoming connection in a dedicated greenlet
def echo(socket, address):
    print('New connection from %s:%s' % address)
    socket.sendall(b'Welcome to the echo server! Type quit to exit.\r\n')
    # using a makefile because we want to use readline()
    stream = socket.makefile(mode='rb')
    while True:
        try:
            # line = stream.readline()
            line = socket.recv(4096)
        except Exception as ex:
            print(ex)
            line = None
        if not line:
            print("client disconnected")
            break
        if line.strip().lower() in (b'quit', b'exit'):
            print("client exit.")
            break
        socket.sendall(line)
        print("echoed %r" % line)
    stream.close()
    return


if __name__ == '__main__':
    # to make the server use SSL, pass certificate file and keyfile arguments to the constructor
    port = 11
    server = StreamServer(('127.0.0.1', port), echo)
    # to start the server asynchronously, use its start() method;
    # we use blocking serve_forever() here because we have no other jobs
    print('Starting echo server on port %s' % port)
    server.serve_forever()
