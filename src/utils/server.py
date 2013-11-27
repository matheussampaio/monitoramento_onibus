import socket
import psycopg2

conn = psycopg2.connect("dbname=gonibus user=postgres")
conn.set_isolation_level(0) # set autocommit

def insertLocalization(placa, lat, lon):
    cur = conn.cursor()

    try:
        cur.execute("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = '{0}'), {1}, {2}, NOW());".format(placa, lat, lon))
        r = cur.statusmessage
    except:
        r = 'fail'

    cur.close()
    return r

def main():
    address = '127.0.0.1'
    port = 5007

    sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
    sock.bind((address, port))

    print 'Servidor iniciado.'

    while True:

        data, addr = sock.recvfrom(1024)

        placa, lat, lon = data.split(',')

        print placa, lat, lon, insertLocalization(placa, lat, lon)

main()