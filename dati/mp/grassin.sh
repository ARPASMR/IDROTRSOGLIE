/usr/local/grass-6.2.2/bin/v.in.ascii input=/cygdrive/d/grassworks/gb/script/mp/mp_input.txt output=idromp format=point fs=" "  skip=0 'columns=ID int, ID2 int, nome varchar(100), x int, y int, bacino varchar(100), data varchar(10), ora varchar(5), fliv int, rangel double precision, difflm double precision, fm int, prlt int, prf int, lung varchar(15), livt varchar(7), liv double precision' x=4 y=5 z=0 cat=1 --overwrite
/usr/local/grass-6.2.2/bin/v.out.ogr input=idromp type=point dsn=/cygdrive/d/grassworks/scambio/ olayer=idromp layer=1 format=ESRI_Shapefile --overwrite
scp /cygdrive/d/grassworks/scambio/idromp.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
