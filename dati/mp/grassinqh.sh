/usr/local/grass-6.2.2/bin/v.in.ascii input=/cygdrive/d/grassworks/gb/script/mp/qhinput.txt output=idroqh format=point fs=" "  skip=0 'columns=ID int, nome varchar(100), x int, y int, bacino varchar(100), data varchar(10), ora varchar(5), liv varchar(7), por varchar(7), simb varchar(1)' x=3 y=4 z=0 cat=1 --overwrite
/usr/local/grass-6.2.2/bin/v.out.ogr input=idroqh type=point dsn=/cygdrive/d/grassworks/scambio/ olayer=idroqh layer=1 format=ESRI_Shapefile --overwrite
scp /cygdrive/d/grassworks/scambio/idroqh.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
