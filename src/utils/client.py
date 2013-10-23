import socket
import sys
from time import sleep

address = '127.0.0.1'
port = 5007
buffer_size = 1024

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    line = 0

    while True:
        line += 1
        if line >= len(coordenadas):
            line = 0

        message = "{0},{1},{2}".format(placa, coordenadas[line][0], coordenadas[line][1])

        s.sendto(message, (address, port))

        sleep(3)


if (sys.argv < 2):
    print "argumentos faltando"
    sys.exit(1)
else:
    try:
        arq = open(sys.argv[1], 'r')
        coordenadas = [line.split(',') for line in arq.read().split('\n')]
        arq.close()
    except:
        print "file {0} not found.".format(sys.argv[1])
        sys.exit(1)

    placa = sys.argv[2]

main()