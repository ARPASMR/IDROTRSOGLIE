#!/bin/bash
# creazione degli shapefile con le ultime misure idrometriche
# esecuzione successiva a idrotrsoglie
#
DIRDATI='/home/meteo/.nmarzi/out/'
DIRGRASS='/usr/lib64/grass/bin/'
DIRGRASSDATA='/home/meteo/grassdata/newLocation/IDRO/dbf/'
${DIRGRASS}v.in.ascii input=${DIRDATI}input24.txt output=idrotr format=point fs=" "  skip=0 'columns=ID int, nome varchar(50), y int, x int, S1 int, S2 int, S3 int, Bacino varchar(20), ID24 int, Data varchar(10), Ora varchar(12), liv double precision, livello varchar(7)' x=4 y=3 z=0 cat=1 --overwrite 
echo "ALTER TABLE idrotr ADD COLUMN sup_soglia INT" | ${DIRGRASS}db.execute
echo "UPDATE idrotr SET sup_soglia=0 WHERE liv < S1" | ${DIRGRASS}db.execute
echo "UPDATE idrotr SET sup_soglia=1 WHERE liv < S2 AND liv >= S1" | ${DIRGRASS}db.execute
echo "UPDATE idrotr SET sup_soglia=2 WHERE liv < S3 AND liv >= S2" | ${DIRGRASS}db.execute
echo "UPDATE idrotr SET sup_soglia=3 WHERE liv >= S3" | ${DIRGRASS}db.execute
echo "UPDATE idrotr SET sup_soglia=-1 WHERE S3 = -9999" | ${DIRGRASS}db.execute
${DIRGRASS}v.out.ogr input=idrotr type=point dsn=${DIRDATI}idrotr olayer=idrotr layer=1 format=ESRI_Shapefile --overwrite
