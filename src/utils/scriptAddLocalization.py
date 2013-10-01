import psycopg2
from time import sleep

arq = open('coordenates500.db', 'r')

listaCoordenadas500 = [line.split(',') for line in arq.read().split('\n')]

arq.close()

arq = open('coordenates505.db', 'r')

listaCoordenadas505 = [line.split(',') for line in arq.read().split('\n')]

arq.close()

arq = open('coordenates555.db', 'r')

listaCoordenadas555 = [line.split(',') for line in arq.read().split('\n')]

arq.close()

def main():
    print('begin...')

    conn = psycopg2.connect("dbname=gonibus user=matheussampaio password=sampaio")

    conn.set_isolation_level(0) # set autocommit

    cur = conn.cursor()

    i, j, k = 0, 0, 0

    while True:

        i += 1
        j += 1
        k += 1

        if i >= len(listaCoordenadas500):
            i = 0

        if j >= len(listaCoordenadas505):
            j = 0

        if k >= len(listaCoordenadas555):
            k = 0


        cur.execute("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0001'), {0}, {1}, NOW());".format(listaCoordenadas500[i][0], listaCoordenadas500[i][1]))
        print("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0001'), {0}, {1}, NOW());".format(listaCoordenadas500[i][0], listaCoordenadas500[i][1]))
        cur.execute("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0004'), {0}, {1}, NOW());".format(listaCoordenadas505[j][0], listaCoordenadas505[j][1]))
        print("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0004'), {0}, {1}, NOW());".format(listaCoordenadas505[j][0], listaCoordenadas505[j][1]))
        cur.execute("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0007'), {0}, {1}, NOW());".format(listaCoordenadas555[k][0], listaCoordenadas555[k][1]))
        print("INSERT INTO Localization VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = 'ABC-0007'), {0}, {1}, NOW());".format(listaCoordenadas555[k][0], listaCoordenadas555[k][1]))

        sleep(3)

    cur.close()

    print('end.')


main()