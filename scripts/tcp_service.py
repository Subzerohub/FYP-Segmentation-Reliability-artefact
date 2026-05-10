#!/usr/bin/env python3
import socket
import sys

port = int(sys.argv[1])
name = sys.argv[2] if len(sys.argv) > 2 else "service"

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(("0.0.0.0", port))
sock.listen(20)

print(f"{name} listening on TCP port {port}", flush=True)

while True:
    conn, addr = sock.accept()
    message = f"{name} OK from {addr}\n".encode()
    conn.sendall(message)
    conn.close()
