import psycopg2
from time import sleep

# listaCoor = range(100)

arq = open('coordenates.db', 'r')

listaCoordenadas = [line.split(',') for line in arq.read().split('\n')]

arq.close()

def main():
    print('begin...')

    conn = psycopg2.connect("dbname=gonibus user=matheussampaio password=sampaio")
    
    conn.set_isolation_level(0) # set autocommit

    cur = conn.cursor()

    for i in range(len(listaCoordenadas)):
        cur.execute("INSERT INTO Localization VALUES (DEFAULT, 1, {0}, {1}, NOW());".format(listaCoordenadas[i][0], listaCoordenadas[i][1]))
        
        print("Localization create: 1, {0}, {1}, NOW());".format(listaCoordenadas[i][0], listaCoordenadas[i][1]))

        sleep(3)

    cur.close()

    print('end.')


main()