import psycopg2

placaOnibus = 'ABC-0007'

arq = open(placaOnibus, 'r')

horarios = [line.split(',') for line in arq.read().split('\n')]

arq.close()

def main():
    print('begin...')

    conn = psycopg2.connect("dbname=gonibus user=matheussampaio password=sampaio")

    conn.set_isolation_level(0) # set autocommit

    cur = conn.cursor()

    seq = 1

    for e in horarios:
        query = "INSERT INTO Horario VALUES (DEFAULT, (SELECT id_onibus FROM Onibus WHERE placa = '{0}'), {1}, (SELECT TIME '{2}'), {3});".format(placaOnibus, e[0], e[1], seq)
        seq += 1

        cur.execute(query)

    cur.close()

    print('end.')


main()