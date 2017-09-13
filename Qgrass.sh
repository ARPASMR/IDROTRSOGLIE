#!/bin/bash
# creazione degli shapefile con le ultime misure idrometriche
# esecuzione successiva a idrotrsoglie
#
DIRDATI='/home/meteo/.nmarzi/out/'
DIRGRASS='/usr/lib64/grass/bin/'
DIRGRASSDATA='/home/meteo/grassdata/newLocation/IDRO/dbf/'

${DIRGRASS}v.in.ascii input=${DIRDATI}inputQ.txt output=Qtr1 format=point fs=" " skip=0 'columns=ID int, nome varchar(50), y int, x int, Bacino varchar(20), Data varchar(10), Ora varchar(12), Q double precision, Q1 int, livello double precision, liv varchar(7), velocita double precision, vel varchar(7)' x=4 y=3 z=0 cat=1 --overwrite
${DIRGRASS}v.out.ogr input=Qtr1 type=point dsn=${DIRDATI}idrotr olayer=Qtr layer=1 format=ESRI_Shapefile --overwrite
