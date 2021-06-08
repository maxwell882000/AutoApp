
import socket

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 65432        # Port to listen on (non-privileged ports are > 1023)

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()

    print('Connected by', addr)
    int_num = 0
    while True:
        data = conn.recv(1024)
        print("DATA COMMING {} {type}".format(data , type=type(data)))
        if not data:
            break
        int_num += 1
        if int_num == 2:
            break
    print("CLOSE FROM LOOP")
    conn.sendall(data)
    conn.close()