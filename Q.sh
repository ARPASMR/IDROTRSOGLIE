#########################################################
#   Q (creazione dei file delle portate)
########################################################
#
#   lo script è copiato da nmarzi ed adattato per il giro su gagliardo
#!/bin/bash
#
# input: file di anagrafica dei sensori sen_Q.txt (directory dati)
# output: 
# prerequisiti:  gnuplot,webservice, grass
#
#### inizializzazione delle variabili
#
# definizioni dei parametri
FILEDATI='/home/meteo/scripts/idrotrsoglie/dati/sen_Q.txt'
FILEZZ='/home/meteo/scripts/idrotrsoglie/tmp/zz.txt'
DIRDATI='/home/meteo/.nmarzi/out/'
DIRJPEG='/home/meteo/scripts/idrotrsoglie/dati/'
DIRLOG='/home/meteo/scripts/idrotrsoglie/log/'
FILELOG='/home/meteo/scripts/idrotrsoglie/log/Q'$now'.log'
DIRTMP='/home/meteo/scripts/idrotrsoglie/tmp/'

##     inizializzazione date  ##
date --date "7 days ago" '+DATE: %d %m %Y %H %M' > ${DIRTMP}time2Q.tmp
read fuffa day2 mon2 year2 ora2 min2 < ${DIRTMP}time2Q.tmp
date --date "0 minute ago" '+DATE: %d %m %Y %H %M' > ${DIRTMP}time1Q.tmp
read fuffa day1 mon1 year1 ora1 min1 < ${DIRTMP}time1Q.tmp

#wc -l /cygdrive/d/grassworks/gb/script/sen_Q.txt > /cygdrive/d/grassworks/gb/script/UU4.txt
#read n u < /cygdrive/d/grassworks/gb/script/UU4.txt
n=`wc -l $FILEDATI | awk '{print $1}'`
for ((x=1; x<=n; x++))
do
	echo "${x}"
	head -$x $FILEDATI | tail -1 > ${DIRTMP}zzQ.txt
	read ID nome N E bac < ${DIRTMP}zzQ.txt
#	echo "R	$ID	${year2}/${mon2}/${day2} ${ora2}:${min2}	${year1}/${mon1}/${day1} ${ora1}:${min1}" > /cygdrive/d/grassworks/gb/script/EstrazioneDati2/IN/Richiesta.txt
#	unix2dos /cygdrive/d/grassworks/gb/script/EstrazioneDati2/IN/Richiesta.txt
#	/cygdrive/d/grassworks/gb/script/EstrazioneDati2/EstrazioneDati.exe
#	dos2unix /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/${ID}_R.txt
	grep -v -e "-9999" ${DIRDATI}${ID}_R.txt | grep -v "999.0" > ${DIRTMP}valgrep_${ID}.txt
	tail -1 ${DIRTMP}valgrep_${ID}.txt > ${DIRDATI}val_${ID}.txt
	#read ID nome N E bac < /cygdrive/d/grassworks/gb/script/zzQ.txt

	if [ ${ID} -eq 3020 ]
	then 
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		cp ${DIRDATI}8147_R.txt ${DIRDATI}8147_RQ.txt
		awk '{ if ( $4 > 0 ) print $1, $2, $3, $4 * 100}' ${DIRDATI}3016_R.txt | sed -e 's/-999900/-9999/g' > ${DIRDATI}3016_RQ.txt
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [*:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}${ID}_R.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}3002_R.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}3016_RQ.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2, \"${DIRDATI}8147_RQ.txt\"  using 2:(\$4) with lines lt 4 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_3002.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_3016.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 

	fi

	if [ ${ID} -eq 3050 ]
	then 
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		cp ${DIRDATI}8394_R.txt ${DIRDATI}8394_RQ.txt
		awk '{ if ( $4 > 0 ) print $1, $2, $3, $4 * 100}' ${DIRDATI}3046_R.txt | sed -e 's/-999900/-9999/g' > ${DIRDATI}3046_RQ.txt
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [*:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}${ID}_R.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}3032_R.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}3046_RQ.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2, \"${DIRDATI}8394_RQ.txt\"  using 2:(\$4) with lines lt 4 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_3032.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_3046.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 
	fi

	if [ ${ID} -eq 3080 ]
	then 
		#mv /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3080_R.txt /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3080_R1.txt
		#sed -e '/-98406/d' /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3080_R1.txt > /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3080_R.txt
		paste ${DIRDATI}3062_R.txt ${DIRDATI}3080_R.txt > ${DIRDATI}306280_R.txt
		awk '{if ($4 >= 165.5) print $1, $2, $3, $4}' ${DIRDATI}306280_R.txt > ${DIRDATI}3062_OK.txt
		awk '{if ($4 >= 165.5) print $5, $6, $7, $8}' ${DIRDATI}/306280_R.txt > ${DIRDATI}3080_R1.txt
		awk '{ if ( $4 > 0 ) print $0}' ${DIRDATI}3080_R1.txt > ${DIRDATI}3080_OK.txt
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		cp ${DIRDATI}8113_R.txt ${DIRDATI}8113_RQ.txt
		awk '{ if ( $4 > 0 ) print $1, $2, $3, $4 * 100}' ${DIRDATI}3076_R.txt | sed -e 's/-999900/-9999/g' > ${DIRDATI}3076_RQ.txt
		

		
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [*:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}${ID}_OK.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}3062_OK.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}3076_RQ.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2, \"${DIRDATI}8113_RQ.txt\"  using 2:(\$4) with lines lt 4 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		tail -1 ${DIRDATI}${ID}_OK.txt > ${DIRDATI}val_${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_3062.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_3076.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 

	fi

	if [ ${ID} -eq 3110 ]
	then 
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		cp ${DIRDATI}14021_R.txt ${DIRDATI}14021_RQg.txt
		sed 's/-99.99/-9999/g' ${DIRDATI}14021_RQg.txt > ${DIRDATI}14021_RQ.txt
		awk '{if ($4 >= 0) print $1, $2, $3, $4 * 100}' ${DIRDATI}3106_R.txt | sed -e 's/-999900/-9999/g' > /${DIRDATI}3106_RQ.txt
		awk '{ if ($4 >= 0) print $1, $2, $3, $4}' ${DIRDATI}3110_R.txt > ${DIRDATI}3110_RQ.txt
		awk '{ if ($4 > -9000) print $1, $2, $3, $4}' ${DIRDATI}3092_R.txt > ${DIRDATI}3092_RQ.txt
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [*:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}${ID}_RQ.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}3092_RQ.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}3106_RQ.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2, \"${DIRDATI}14021_RQ.txt\"  using 2:(\$4) with lines lt 4 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_3092.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_3106.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 
	fi

	if [ ${ID} -eq 3136 ]
	then 
		paste ${DIRDATI}${ID}_R.txt ${DIRDATI}3132_R.txt > ${DIRDATI}paste1.txt
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		#awk '{print $1, $2, $3, $4, $5, $6, $7, $8 * 100}' /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/paste1.txt | sed -e 's/-999900/-9999/g' > /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/paste.txt
		awk '{if ( $8 < 0 ) print $1, $2, $3, $4, $5, $6, $7, 0; else print $1, $2, $3, $4, $5, $6, $7, $8 * 100}' ${DIRDATI}paste1.txt | sed -e 's/-999900/-9999/g' > ${DIRDATI}paste.txt
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		#set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [0:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}paste.txt\"  using 2:(\$8>=0?\$4:1/0) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}3118_R.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}paste.txt\"  using 2:(\$8>=0?\$8:1/0) with lines lt 5 lw 1 axes x1y2"
		#plot \"/cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/${ID}_R.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"/cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3118_R.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"/cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/3132_R.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_3118.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_3132.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 
	fi

	if [ ${ID} -eq 30530 ]
	then 
		yy=`awk '$4>m{m=$4}END{print m}' ${DIRDATI}${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyyy=${int}+20
		cp ${DIRDATI}8121_R.txt ${DIRDATI}8121_RQ.txt
		awk '{ if ( $4 > 0 ) print $1, $2, $3, $4 * 100}' ${DIRDATI}30528_R.txt | sed -e 's/-999900/-9999/g' > ${DIRDATI}30528_RQ.txt
		{ 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPEG}${ID}.jpeg\"
		set title \"Portate stazione di ${nome} (dati non validati)\"
		set grid
		unset key
		set datafile missing \"-9999\"
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"Portata [m3/s]\" tc lt 1
		set y2label \"livello [cm]\" tc lt 3
		set y2tics
		set ytics nomirror
		set pointsize 0.8
		set label \"velocita' [cm/s]\" at graph 0.97, 0.38 rotate left tc lt 5
		set label \"livello CAE [cm]\" at screen 0.975, 0.7 rotate left tc lt 4
		#set yrange [*:${yyyy}]
		set autoscale y2
		set autoscale y
		plot \"${DIRDATI}${ID}_R.txt\"  using 2:(\$4) with lines lt 1 lw 1 axes x1y1, \"${DIRDATI}30527_R.txt\" using 2:(\$4) with lines lt 3 lw 1 axes x1y2, \"${DIRDATI}30528_RQ.txt\"  using 2:(\$4) with lines lt 5 lw 1 axes x1y2, \"${DIRDATI}8121_RQ.txt\"  using 2:(\$4) with lines lt 4 lw 1 axes x1y2"
		} > ${DIRTMP}input${ID}.txt
		gnuplot ${DIRTMP}input${ID}.txt
		#rm /cygdrive/d/grassworks/gb/script/input${ID}.txt
		read ID giorno ora Q < ${DIRDATI}val_${ID}.txt
		read fuffa fuffa1 fuffa2 liv < ${DIRDATI}val_30527.txt
		read fuffa fuffa1 fuffa2 vel1 < ${DIRDATI}val_30528.txt
		vel=`echo ${vel1}*100 | bc -l`
		echo "$ID $giorno $ora $Q $liv $vel" > ${DIRDATI}${ID}_Q.tmp 
	fi


done


cat ${DIRDATI}*_Q.tmp | sed 's/:00.000//g' | sort > ${DIRDATI}portate.tmp
cat ${DIRDATI}portate.tmp | awk '{ printf ("%0.f %-s %-s %.1f %0.f %.1f %-s %.1f %-s\n", $1, $2, $3, $4, $4, $5, $5, $6, $6)}' | sort > ${DIRDATI}portate.txt
join $FILEDATI ${DIRDATI}portate.txt > ${DIRDATI}inputQ.txt
 cat /home/meteo/scripts/idrotrsoglie/Qgrass.sh |grass -text /home/meteo/grassdata/newLocation/IDRO 2&> ${DIRLOG}tr_idro_checkQ_${now}.log

scp ${DIRDATI}idrotr/Qtr.* idroweb@172.16.1.11:/var/www/idro/pmapper_demodata
scp ${DIRJPEG}3*.jpeg idroweb@172.16.1.11:/var/www/idro/manual
## rm /cygdrive/d/grassworks/gb/script/zzQ.txt /cygdrive/d/grassworks/gb/script/time*Q.tmp #/cygdrive/d/grassworks/gb/script/*_Q.tmp #/cygdrive/d/grassworks/gb/script/UU4.txt
