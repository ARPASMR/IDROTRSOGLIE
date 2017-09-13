#!/bin/bash
# creazione degli shapefile con le ultime misure di portata da curva di deflusso
# esecuzione successiva a duratetempdaiCxdum
#
DIRDATI='/home/meteo/.nmarzi/out/'
DIRMP='/home/meteo/scripts/idrotrsoglie/dati/mp/'
DIRGRASS='/usr/lib64/grass/bin/'
DIRGRASSDATA='/home/meteo/grassdata/newLocation/IDRO/dbf/'



${DIRGRASS}v.in.ascii input=${DIRMP}qhinput.txt output=idroqh format=point fs=" "  skip=0 'columns=ID int, nome varchar(100), x int, y int, bacino varchar(100), data varchar(10), ora varchar(5), liv varchar(7), por varchar(7), simb varchar(1)' x=3 y=4 z=0 cat=1 --overwrite
${DIRGRASS}v.out.ogr input=idroqh type=point dsn=${DIRDATI}idrotr olayer=idroqh layer=1 format=ESRI_Shapefile --overwrite
scp ${DIRDATI}idrotr/idroqh.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
