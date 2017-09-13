#########################################################
#  idrotrsoglie ver. 3
########################################################
#
#   lo script è copiato da nmarzi ed adattato per il giro su gagliardo
#!/bin/bash
#
# input: file di anagrafica dei sensori ie4bac.txt (directory dati)
# output: serie di file jpeg con i plottaggi dei livelli idrometrici
# prerequisiti: gnuplot, webservice
#
#### inizializzazione delle variabili
#
# definizioni dei parametri 
a=0.0172486353338794
b=0
c=0.772260370049265
a1=0.00340572548707515
b1=0
c1=1.5127696439526
a2=0.00238638497523377
b2=1.00013632305095
c2=1.5779694806735
now=$(date +"%Y_%m_%d")
FILEDATI='/home/meteo/scripts/idrotrsoglie/dati/stazioni.txt'
FILEZZ='/home/meteo/scripts/idrotrsoglie/tmp/zz.txt'
DIRDATI='/home/meteo/.nmarzi/out/'
DIRJPEG='/home/meteo/scripts/idrotrsoglie/dati/'
DIRLOG='/home/meteo/scripts/idrotrsoglie/log/'
FILELOG='/home/meteo/scripts/idrotrsoglie/log/idrotrsoglie'$now'.log'
DIRTMP='/home/meteo/scripts/idrotrsoglie/tmp/'

##     inizializzazione date  ##

date --date "7 days ago" '+DATE: %d %m %Y %H %M' > ${DIRTMP}time2i.txt
read fuffa day2 mon2 year2 ora2 min2 < ${DIRTMP}time2i.txt
date --date "0 minute ago" '+DATE: %d %m %Y %H %M' > ${DIRTMP}time1i.txt
read fuffa day1 mon1 year1 ora1 min1 < ${DIRTMP}time1i.txt

touch $FILELOG
date --date "0 minute ago" '+DATE: %H %M' >> $FILELOG
#wc -l /cygdrive/d/grassworks/gb/script/ie4bac.txt > /cygdrive/d/grassworks/gb/script/UU3.txt
#read n u < /cygdrive/d/grassworks/gb/script/UU3.txt
#################################################################
#                    ciclo su sensori
##################################################################
n=`wc -l $FILEDATI | awk '{print $1}'`
n_file_0=0
for ((x=1; x<=n; x++))
do
	echo "${x}"
	echo "${x}" >> $FILELOG
	head -$x $FILEDATI | tail -1 > $FILEZZ
	read ID nome N E s1 s2 s3 bac < $FILEZZ
	echo "inizio ciclo stazioni" >> $FILELOG
	echo "stazione: $ID" >> $FILELOG
#	echo "R	$ID	${year2}/${mon2}/${day2} ${ora2}:${min2}	${year1}/${mon1}/${day1} ${ora1}:${min1}" > /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
#	unix2dos /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
#	/cygdrive/d/grassworks/gb/script/EstrazioneDati/EstrazioneDati.exe
#	dos2unix /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt
#
#   Controllo se i file sono vuoti
#
FILENAME=$DIRDATI${ID}_R.txt
FILESIZE=$(stat -c%s "$FILENAME")
if [ $FILESIZE -eq 0 ] 
	then
		((n_file_0++))
fi
	if [ $ID -eq 9079 ]
		then
		mv $DIRDATI9079_R.txt $DIRDATI9079_R1.txt
		sed -e '/-251/d' $DIRDATI9079_R1.txt > $DIRDATI9079_R.txt
	fi
	if [ $ID -eq 14307 ]
		then
		mv $DIRDATI14307_R.txt $DIRDATI14307_R1.txt
		sed -e '/-469/d' $DIRDATI14307_R1.txt > $DIRDATI14307_R.txt
	fi
	if [ $ID -eq 8142 ]
		then
		mv $DIRDATI8142_R.txt $DIRDATI8142_R1.txt
		sed -e '/-728/d' $DIRDATI8142_R1.txt > $DIRDATI8142_R.txt
	fi
	if [ $ID -eq 3118 ]
		then
		mv $DIRDATI3118_R.txt $DIRDATI3118_R1.txt
		awk '{print $1, $2, $3, $4*100}' $DIRDATI3118_R1.txt > $DIRDATI3118_R.txt
	fi
	if [ $ID -eq 14024 ]
		then
		mv $DIRDATI14024_R.txt $DIRDATI14024_R1.txt
		grep -ve "-2[1234567890][1234567890]" $DIRDATI14024_R1.txt > $DIRDATI14024_R.txt
	fi
	if [ $ID -eq 14024 ]
		then
		mv $DIRDATI14024_R.txt $DIRDATI14024_R1.txt
		grep -ve "-1[1234567890][1234567890]" $DIRDATI14024_R1.txt > $DIRDATI14024_R.txt
	fi
#
# modifiche x funzionamento con grass	
#
       tail -1 $DIRDATI${ID}_R.txt > ${DIRDATI}val_${ID}.txt
#       tail -144 /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt > /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_24R.txt
	let yr=${s3}+20
	echo "limiti ordinate ${s1} ${s2} ${s3} $yr\n" >> $FILELOG

	if ( [[ ${s2} -ne -9999 ]] && [[ ${s2} -ne ${s1} ]] )
	then
		yy=`awk '$4>m{m=$4}END{print m}' $DIRDATI${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		if [ ${s3} -ge ${int} ]
		then
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @  ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"ordinario\" at \"${year2}-${mon2}-${day2} 12:00\",${s1} offset 0,1
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"ordinario\" at \"${year2}-${mon2}-${day2} 12:00\",${s1} offset 0,1
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt 
		gnuplot $DIRTMP${ID}.txt >> $FILELOG 
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi 
		if [ ${s3} -lt ${int} ]
		then
		let yyyy=${int}+20
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"ordinario\" at \"${year2}-${mon2}-${day2} 12:00\",${s1} offset 0,1
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"ordinario\" at \"${year2}-${mon2}-${day2} 12:00\",${s1} offset 0,1
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi
	fi

	if ( [[ ${s2} -ne -9999 ]] && [[ ${s2} -eq ${s1} ]]  && [[ ${s2} -ne ${s3} ]] )
	then
		yy=`awk '$4>m{m=$4}END{print m}' $DIRDATI${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		if [ ${s3} -ge ${int} ]
		then
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi 

		
		if [ ${s3} -lt ${int} ]
		then
		let yyyy=${int}+20
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"moderato\" at \"${year2}-${mon2}-${day2} 12:00\",${s2} offset 0,1
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi
	fi

	if ( [[ ${s3} -eq ${s2} ]] && [[ ${s3} -ne -9999 ]] )
	then
		yy=`awk '$4>m{m=$4}END{print m}' $DIRDATI${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		if [ ${s3} -ge ${int} ]
		then
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yr}]
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi 
		if [ ${s3} -lt ${int} ]
		then
		let yyyy=${int}+20
		{ 
		echo "set terminal png giant size 950,666
		set encoding utf8
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [*:${yyyy}]
		set label \"elevato\" at \"${year2}-${mon2}-${day2} 12:00\",${s3} offset 0,1
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3, ${s1} w lines lt 2 lw 3, ${s2} w lines lt 7 lw 3, ${s3} w lines lt 1 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		fi
	fi

	if [ ${s3} -eq -9999 ]
		then
		yy=`awk '$4>m{m=$4}END{print m}' $DIRDATI${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyy=${int}+30
		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24_s.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt
	fi

               	yy=`awk '$4>m{m=$4}END{print m}' $DIRDATI${ID}_R.txt`
                int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
                let yyy=${int}+30

 
	        {
	        echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"$DIRDATI${ID}_R.txt\" using 2:4 with lines lt 3 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"$DIRJPEG${ID}_24.jpeg\"
		set title \"${bac} @ ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"$DIRDATI${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3"
		} > $DIRTMP${ID}.txt
		gnuplot $DIRTMP${ID}.txt >> $FILELOG
		cat $DIRTMP${ID}.txt >> $FILELOG
		rm $DIRTMP${ID}.txt

done
echo "finito !\n" >> $FILELOG
if [ $n_file_0 -gt 60 ] 
	then
	logger -is -p user.err "idrotrsoglie: ci sono $n_file_0 file a 0 byte" -t "IDRO"
else
	logger -is -p user.notice "idrotrsoglie: acquisizione regolare" -t "IDRO"
fi	
# #########################################
# fase finale (per ora commentata)
###########################################
 cat ${DIRDATI}val_*.txt | sed 's/:00.000//g' | sort -n > ${DIRDATI}idrometri24.txt
 cat ${DIRDATI}idrometri24.txt | awk '{ printf ("%0.f %0.f %-s %-s %.1f %0.f\n", $1, $1, $2, $3, $4, $4)}' | sort -n > ${DIRDATI}idrometriok24.txt
 join $FILEDATI ${DIRDATI}idrometriok24.txt > ${DIRDATI}input24.txt
 scp $DIRJPEG*.jpeg idroweb@172.16.1.11:/var/www/idro/manual
 cat /home/meteo/scripts/idrotrsoglie/grassinidro324.sh | grass -text /home/meteo/grassdata/newLocation/IDRO/   2&> ${DIRLOG}tr_idro_check3_${now}.log
 scp ${DIRDATI}idrotr/idrotr.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
# rm /cygdrive/d/grassworks/gb/script/zz.txt /cygdrive/d/grassworks/gb/script/val_*.txt # /cygdrive/d/grassworks/gb/script/UU3.txt
