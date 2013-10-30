#!/usr/bin/env bash

apt-get update

# Clonando repositorio
apt-get install -y git curl vim nodejs python-psycopg2 python-pip tomcat7 unzip
git clone --branch=vagrant https://github.com/matheussampaio/monitoramento_onibus.git

# Instalando Postgres
apt-get install -y postgresql-9.1-postgis -q
cp monitoramento_onibus/vagrant/pg_hba.conf /etc/postgresql/9.1/main/
/etc/init.d/postgresql restart

# Criando servidor de teste
# psql -c 'create database teste;' -U postgres
# psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql -U postgres
# psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql  -U postgres
# psql -d teste -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql -U postgres

# Servidor para deploy
psql -c 'create database gonibus;' -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql  -U postgres
psql -d gonibus -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql -U postgres

# Instalando dependencias
# apt-get install -y python-pip
# apt-get install -y python-psycopg2
pip install unittest-xml-reporting

# Instalando o NodeJS
# apt-get install -y nodejs

# Instalando Apache
# apt-get install -y tomcat7

# Instalando GeoServer
# apt-get install unzip
wget http://sourceforge.net/projects/geoserver/files/GeoServer/2.3.5/geoserver-2.3.5-war.zip
unzip geoserver-2.3.5-war.zip
cp geoserver.war /var/lib/tomcat7/webapps/

# Executando testes
cd monitoramento_onibus/src
python setup.py

sleep 120

# Configurando o GeoServer
curl -v -u admin:geoserver -XPOST -H "Content-type: text/xml"  -d "<workspace><name>GO</name></workspace>"  http://localhost:8080/geoserver/rest/workspaces
curl -v -u admin:geoserver -XPOST -T /home/vagrant/monitoramento_onibus/src/geoserverFiles/gonibusDataStore.xml -H "Content-type: text/xml"  http://localhost:8080/geoserver/rest/workspaces/GO/datastores