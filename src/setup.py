import psycopg2
import os
import sys

server = 'gonibus'

if (len(sys.argv) > 1 and sys.argv[1] == 'test'):
    server = 'teste'

conn = psycopg2.connect("dbname=" + server + " user=postgres")
conn.set_isolation_level(0) # set autocommit
cur = conn.cursor()

def createAll(path, msg):
    for e in os.listdir(path):
        arq = open(path + '/' + e, 'r')
        try:
            cur.execute( arq.read() )
            print '{0} .. OK'.format(e)
        except psycopg2.ProgrammingError as err:
            print '{0} .. FAIL'.format(e), err
        arq.close()

createAll('sql/news/enums', 'CREATE TYPE')
createAll('sql/news/tables', 'CREATE TABLE')

cur.execute("SELECT AddGeometryColumn('','rota','geom','4291','LINESTRING',2);")
cur.execute("SELECT AddGeometryColumn('','pontoonibus','geom','4291','POINT',2);")

createAll('sql/news/alters', 'ALTER TABLE')
createAll('sql/news/functions', 'CREATE FUNCTION')
createAll('sql/news/triggers', 'CREATE TRIGGER')
createAll('sql/news/views', 'CREATE VIEW')