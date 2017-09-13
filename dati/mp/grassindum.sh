#!/bin/bash
# creazione degli shapefile con le ultime misure di portata da curva di deflusso
# esecuzione successiva a duratetempdaiCxdum
#
DIRDATI='/home/meteo/.nmarzi/out/'
DIRGRASS='/usr/lib64/grass/bin/'
DIRGRASSDATA='/home/meteo/grassdata/newLocation/IDRO/dbf/'

${DIRGRASS}v.in.ascii input=${DIRDATI}mp_inputdum.txt output=idromp format=point fs=" "  skip=0 'columns=ID int, ID2 int, nome varchar(100), dum int, x int, y int, bacino varchar(100), data varchar(10), ora varchar(5), fliv int, rangel double precision, difflm double precision, fm int, prlt int, prf int, lung varchar(15), livt varchar(7), liv double precision' x=5 y=6 z=0 cat=1 --overwrite
${DIRGRASS}v.out.ogr input=idromp type=point dsn=${DIRDATI}idrotr olayer=idromp layer=1 format=ESRI_Shapefile --overwrite
scp ${DIRDATI}idrotr/idromp.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
