#!/usr/bin/env bash

apt-get update

# Instalando Dependencias:
apt-get install -y git curl vim nodejs python-psycopg2 python-pip tomcat7 unzip

# Clonando Repositorio:
git clone https://github.com/matheussampaio/monitoramento_onibus.git

# Instalando Postgres
apt-get install -y postgresql-9.1-postgis -q
cp /home/vagrant/monitoramento_onibus/pg_hba.conf /etc/postgresql/9.1/main/
/etc/init.d/postgresql restart

# Criando database teste
psql -c 'create database teste;' -U postgres
psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql -U postgres
psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql  -U postgres
psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql -U postgres

# Criando database gonibus
psql -c 'create database gonibus;' -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql  -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql -U postgres

# Instalando GeoServer
wget http://sourceforge.net/projects/geoserver/files/GeoServer/2.3.5/geoserver-2.3.5-war.zip
unzip geoserver-2.3.5-war.zip
cp geoserver.war /var/lib/tomcat7/webapps/

website="http://localhost:8080/geoservers"

wget -q --spider $website

while [ $? == 8 ];
do
  echo "Waiting for GeoServer"
  sleep 30

  wget -q --spider $website
done

# Configurando o GeoServer
 curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml"  -d "<workspace><name>GO</name></workspace>"  http://localhost:8080/geoserver/rest/workspaces
 curl -v -u admin:geoserver -XPOST -T monitoramento_onibus/src/geoserverFiles/gonibusDataStore.xml -H "Content-type: text/xml"  http://localhost:8080/geoserver/rest/workspaces/GO/datastores

# Executando testes
cd monitoramento_onibus/src
python setup.py
