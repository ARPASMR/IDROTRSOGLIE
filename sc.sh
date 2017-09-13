#!/bin/bash
###############################
#  sc.sh
#
# creazione dei grafici delle scale di deflusso
###################################
DIRMP='/home/meteo/scripts/idrotrsoglie/dati/mp/'
DIRDATI='/home/meteo/.nmarzi/out/'
DIRJPG='/home/meteo/scripts/idrotrsoglie/dati/'
DIRGRASS='/usr/lib64/grass/bin/'
# lettura dai file di anagrafica
n=`wc -l ${DIRMP}param_sc.txt | awk '{print $1}'`
awk '{if ($13 < 150) print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' ${DIRMP}gaugings.txt > ${DIRMP}gaug.tmp 
for ((x=1; x<=n; x++))
do
    head -$x ${DIRMP}param_sc.txt | tail -1 > ${DIRMP}sc.tmp
    read ID nome num fuffa < ${DIRMP}sc.tmp

    if ( [[ $ID -eq 3002 ]] || [[ $ID -eq 3092 ]] || [[ $ID -eq 3032 ]] )
       then
       grep -v "9999" ${DIRDATI}${ID}_R.txt | grep -v "99900" | tail -1 > ${DIRMP}val_${ID}.tmp
       maxll=`awk '{print $4/100}' ${DIRDATI}${ID}_R.txt | sort -n | tail -1`
       minl=`awk '{print $4/100}' ${DIRDATI}${ID}_R.txt | sort -n | sed -n -e 1p`
       echo $x ${minl} ${maxll}
    else
       tail -1 ${DIRDATI}${ID}_R.txt > ${DIRMP}val_${ID}.tmp
       maxll=`awk '{print $4/100}' ${DIRDATI}${ID}_R.txt | sort -n | tail -1`
       minl=`awk '{print $4/100}' ${DIRDATI}${ID}_R.txt | sort -n | sed -n -e 1p`
       echo $x ${minl} ${maxll}
    fi
    read fuffa fuffa1 fuffa2 valcm < ${DIRMP}val_${ID}.tmp
    if [ ${num} = "1num" ]
       then
       read ID nome num1 a b c i1 i2 datav < ${DIRMP}sc.tmp
       grep -e "$nome" ${DIRMP}gaug.tmp | awk '{print $1, $4, $10, $11}' > ${DIRMP}gauga${ID}.tmp
       sed 's/\// /g' ${DIRMP}gauga${ID}.tmp | awk '{print $1, $2"/"$3"/"$4, $4$3$2, $5, $6}' > ${DIRMP}gaugb${ID}.tmp
       awk -v data=${datav} '{ if ($3 >= data) print $1, $2, $4, $5}' ${DIRMP}gaugb${ID}.tmp > ${DIRMP}gaug${ID}.tmp
       if ( [[ $ID -eq 3002 ]] || [[ $ID -eq 3092 ]] || [[ $ID -eq 3032 ]] )
          then
          awk -v a=$a -v b=$b -v c=$c '{print $2, $3, $4/100, a*($4/100+b)^c}' ${DIRDATI}${ID}_R.txt > ${DIRMP}qdat.tmp
    else
          awk -v a=$a -v b=$b -v c=$c '{print $2, $3, $4/100, a*($4/100+b)^c}' ${DIRDATI}${ID}_R.txt > ${DIRMP}qdat.tmp
       fi
       val1=`echo "$valcm*0.01" | bc -l`
       val2=`echo "${a}*e(${c}*l(${val1}+${b}))" | bc -l`
       echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
       awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       maxl=`echo ${i2} ${maxll} | awk -v h=${i2} -v g=${maxll} '{if (h > g) print h; else print g}'`
                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}sc.png\"
		set title \"Stazione di ${nome} - Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}\"
		set grid lt 0 lw 1
		unset key
		set y2tics nomirror
		set xlabel \"Livello [m]\"
		#set x2label \"portata misure\"
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set pointsize 0.8
		set xrange [${i1}:${maxl}]
		set yrange [0:${a}*(${maxl}+${b})**${c}]
		set y2range [0:${a}*(${maxl}+${b})**${c}]
		#set autoscale y2
		plot x<${maxl} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}gaug${ID}.tmp\" u 3:4 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"${DIRMP}gaug${ID}.tmp\" u (\$3):(\$4+2):2 with labels rotate left axes x1y2, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputsc${nome}.txt
		gnuplot ${DIRMP}inputsc${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}scnm.png\"
		set title \"Stazione di ${nome}\n Scala valida dal ${datav}\n a=${a}; b=${b}; c=${c} per ${i1}<=H[m]<=${i2}\n valore alle ${fuffa2} del ${fuffa1}\"
		set grid lt 0 lw 1
		unset key
		set y2tics nomirror
		set xlabel \"Livello [m]\"
		#set x2label \"portata misure\"
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set pointsize 0.8
		set xrange [${i1}:${maxl}]
		set yrange [0:${a}*(${maxl}+${b})**${c}]
		set y2range [0:${a}*(${maxl}+${b})**${c}]
		set arrow from ${i1},0 to ${i1},(${a}*(${i1}+${b})**${c}) 
		set arrow from ${i2},0 to ${i2},(${a}*(${i2}+${b})**${c})
		#set autoscale y2
		plot x<${maxl} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputscnm${nome}.txt
		gnuplot ${DIRMP}inputscnm${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}Q.png\"
		set title \"Stazione di ${nome}\n Livelli e Portate ultimi 7 giorni (dati non validati)\"
		set grid
		unset grid
		set y2tics 0.1
		set y2tics nomirror
		set ytics nomirror
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"Giorno\"
		set ylabel \"Portata [mc/s]\"
		set y2label \"Livello [m]\"
		set xtics nomirror
		set pointsize 0.8
		set yrange [0:${a}*(${maxl}+${b})**${c}]
		set autoscale y2
		plot \"${DIRMP}qdat.tmp\" u 1:4 with lines lt 1 lw 2 axes x1y1 title \"portata\", \"${DIRMP}qdat.tmp\" u 1:3 with lines lt 3 lw 2 axes x1y2 title \"livello\""
		} > ${DIRMP}inputsc${nome}.txt
		gnuplot ${DIRMP}inputsc${nome}.txt

    fi

    if [ $num = "2num" ]
       then
       val1=`echo "$valcm*0.01" | bc -l`
       read ID nome num1 a b c i1 i2 a1 b1 c1 i11 i22 datav < ${DIRMP}sc.tmp
       grep -e "$nome" ${DIRMP}gaug.tmp | awk '{print $1, $4, $10, $11}' > ${DIRMP}gauga${ID}.tmp
       sed 's/\// /g' ${DIRMP}gauga${ID}.tmp | awk '{print $1, $2"/"$3"/"$4, $4$3$2, $5, $6}' > ${DIRMP}gaugb${ID}.tmp
       awk -v data=${datav} '{ if ($3 >= data) print $1, $2, $4, $5}' ${DIRMP}gaugb${ID}.tmp > ${DIRMP}gaug${ID}.tmp
       awk -v a=$a -v b=$b -v c=$c -v i=$i2 -v e=$a1 -v f=$b1 -v g=$c1 '{if ($4/100 < i) print $2, $3, $4/100, a*($4/100+b)^c; else print $2, $3, $4/100, e*($4/100+f)^g}' ${DIRDATI}${ID}_R.txt > ${DIRMP}qdat2.tmp
       if [ "$(echo ${val1} '<' ${i2} | bc -l)" -eq 1 ]
          then
	  val2=`echo "${a}*e(${c}*l(${val1}+${b}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       else
          val2=`echo "${a1}*e(${c1}*l(${val1}+${b1}))" | bc -l`
 	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       fi
       maxl=`echo ${i22} ${maxll} | awk -v h=${i22} -v g=${maxll} '{if (h > g) print h; else print g}'`
       { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}sc.png\"
		set title \"Stazione di ${nome} - Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; a1=${a1}; b1=${b1}; c1=${c1}\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a1}*(${maxl}+${b1})**${c1}]
		set y2range [0:${a1}*(${maxl}+${b1})**${c1}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<=${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<=${maxl} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, \"${DIRMP}gaug${ID}.tmp\" u 3:4 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"${DIRMP}gaug${ID}.tmp\" u (\$3):(\$4+2):2 with labels  rotate left axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputsc${nome}.txt
		gnuplot ${DIRMP}inputsc${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}scnm.png\"
		set title \"Stazione di ${nome} \n Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; per ${i1}<=H[m]<=${i2} \n a1=${a1}; b1=${b1}; c1=${c1} per ${i11}<H[m]<=${i22} \n valore del ${fuffa1} alle ${fuffa2}\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a1}*(${maxl}+${b1})**${c1}]
		set y2range [0:${a1}*(${maxl}+${b1})**${c1}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set arrow from ${i1},0 to ${i1},(${a}*(${i1}+${b})**${c}) 
		set arrow from ${i22},0 to ${i22},(${a1}*(${i22}+${b1})**${c1})
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<=${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<=${maxl} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputscnm${nome}.txt
		gnuplot ${DIRMP}inputscnm${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}Q.png\"
		set title \"Stazione di ${nome}\n Livelli e Portate ultimi 7 giorni (dati non validati)\"
		unset grid
		set y2tics 0.1
		set y2tics nomirror
		set ytics nomirror
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"Giorno\"
		set ylabel \"Portata [mc/s]\"
		set y2label \"Livello [m]\"
		set xtics nomirror
		set pointsize 0.8
		set yrange [0:${a1}*(${maxl}+${b1})**${c1}]
		set autoscale y2
		plot \"${DIRMP}qdat2.tmp\" u 1:4 with lines lt 1 lw 2 axes x1y1 title \"portata\", \"${DIRMP}qdat2.tmp\" u 1:3 with lines lt 3 lw 2 axes x1y2 title \"livello\""
		} > ${DIRMP}inputsc2${nome}.txt
		gnuplot ${DIRMP}inputsc2${nome}.txt

    fi

    if [ $num = "3num" ]
       then
       val1=`echo "$valcm*0.01" | bc -l`
       read ID nome num1 a b c i1 i2 a1 b1 c1 i11 i22 a2 b2 c2 i13 i23 datav < ${DIRMP}sc.tmp
       grep -e "$nome" ${DIRMP}gaug.tmp | awk '{print $1, $4, $10, $11}' > ${DIRMP}gauga${ID}.tmp
       sed 's/\// /g' ${DIRMP}gauga${ID}.tmp | awk '{print $1, $2"/"$3"/"$4, $4$3$2, $5, $6}' > ${DIRMP}gaugb${ID}.tmp
       awk -v data=${datav} '{ if ($3 >= data) print $1, $2, $4, $5}' ${DIRMP}gaugb${ID}.tmp > ${DIRMP}gaug${ID}.tmp
       awk -v a=$a -v b=$b -v c=$c -v i=$i2 -v e=$a1 -v f=$b1 -v g=$c1 -v ii=$i22 -v a2=$a2 -v b2=$b2 -v c2=$c2 -v iii=$i23 '{if ($4/100 < i) print $2, $3, $4/100, a*($4/100+b)^c; if ($4/100 >= i && $4/100 < ii) print $2, $3, $4/100, e*($4/100+f)^g; else print $2, $3, $4/100, a2*($4/100+b2)^c2}' ${DIRDATI}${ID}_R.txt > ${DIRMP}qdat2.tmp
       if [ "$(echo ${val1} '<' ${i2} | bc -l)" -eq 1 ]
          then
	  val2=`echo "${a}*e(${c}*l(${val1}+${b}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat

       elif [ "$(echo ${val1} '>=' ${i22} | bc -l)" -eq 1 ]
       then
	  val2=`echo "${a2}*e(${c2}*l(${val1}+${b2}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       else
          val2=`echo "${a1}*e(${c1}*l(${val1}+${b1}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       fi
       maxl=`echo ${i23} ${maxll} | awk -v h=${i23} -v g=${maxll} '{if (h > g) print h; else print g}'`
                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}sc.png\"
		set title \"Stazione di ${nome} - Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; a1=${a1}; b1=${b1}; c1=${c1}; a2=${a2}; b2=${b2}; c2=${c2}\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a2}*(${maxl}+${b2})**${c2}]
		set y2range [0:${a2}*(${maxl}+${b2})**${c2}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<${i22} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, ${i22}<=x && x<=${maxl} ? ${a2}*(x+(${b2}))**${c2} : 1/0 axes x1y1,\"${DIRMP}gaug${ID}.tmp\" u 3:4 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"${DIRMP}gaug${ID}.tmp\" u (\$3):(\$4+2):2 with labels  rotate left axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputsc${nome}.txt
		gnuplot ${DIRMP}inputsc${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}scnm.png\"
		set title \"Stazione di ${nome} \n Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; per ${i1}<=H[m]<=${i2} \n a1=${a1}; b1=${b1}; c1=${c1} per ${i11}<H[m]<=${i22} \n a2=${a2}; b2=${b2}; c2=${c2} per ${i13}<H[m]<=${i23} \n valore del ${fuffa1} alle ${fuffa2}\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a2}*(${maxl}+${b2})**${c2}]
		set y2range [0:${a2}*(${maxl}+${b2})**${c2}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set arrow from ${i1},0 to ${i1},(${a}*(${i1}+${b})**${c}) 
		set arrow from ${i23},0 to ${i23},(${a2}*(${i23}+${b2})**${c2})
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<${i22} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, ${i22}<=x && x<=${maxl} ? ${a2}*(x+(${b2}))**${c2} : 1/0 axes x1y1, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputscnm${nome}.txt
		gnuplot ${DIRMP}inputscnm${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}Q.png\"
		set title \"Stazione di ${nome}\n Livelli e Portate ultimi 7 giorni (dati non validati)\"
		unset grid
		set y2tics 0.1
		set y2tics nomirror
		set ytics nomirror
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"Giorno\"
		set ylabel \"Portata [mc/s]\"
		set y2label \"Livello [m]\"
		set xtics nomirror
		set pointsize 0.8
		set yrange [0:${a2}*(${maxl}+${b2})**${c2}]
		set autoscale y2
		plot \"${DIRMP}qdat2.tmp\" u 1:4 with lines lt 1 lw 2 axes x1y1 title \"portata\", \"${DIRMP}qdat2.tmp\" u 1:3 with lines lt 3 lw 2 axes x1y2 title \"livello\""
		} > ${DIRMP}inputsc2${nome}.txt
		gnuplot ${DIRMP}inputsc2${nome}.txt

    fi

    if [ $num = "4num" ]
       then
       val1=`echo "$valcm*0.01" | bc -l`
       read ID nome num1 a b c i1 i2 a1 b1 c1 i11 i22 a2 b2 c2 i13 i23 a3 b3 c3 i14 i24 datav < ${DIRMP}sc.tmp
       grep -e "$nome" ${DIRMP}gaug.tmp | awk '{print $1, $4, $10, $11}' > ${DIRMP}gauga${ID}.tmp
       sed 's/\// /g' ${DIRMP}gauga${ID}.tmp | awk '{print $1, $2"/"$3"/"$4, $4$3$2, $5, $6}' > ${DIRMP}gaugb${ID}.tmp
       awk -v data=${datav} '{ if ($3 >= data) print $1, $2, $4, $5}' ${DIRMP}gaugb${ID}.tmp > ${DIRMP}gaug${ID}.tmp
       awk -v a=$a -v b=$b -v c=$c -v i=$i2 -v e=$a1 -v f=$b1 -v g=$c1 -v ii=$i22 -v a2=$a2 -v b2=$b2 -v c2=$c2 -v i3=$i23 -v a3=$a3 -v b3=$b3 -v c3=$c3 '{if ($4/100 < i) print $2, $3, $4/100, a*($4/100+b)^c; if ($4/100 >= i && $4/100 < ii) print $2, $3, $4/100, e*($4/100+f)^g; if ($4/100 >= ii && $4/100 < i3) print $2, $3, $4/100, a2*($4/100+b2)^c2; if ($4/100 >= i3) print $2, $3, $4/100, a3*($4/100+b3)^c3}' ${DIRDATI}${ID}_R.txt > ${DIRMP}qdat2.tmp
       cp ${DIRMP}qdat2.tmp ${DIRMP}qdat2.dat4
       if [ "$(echo ${val1} '<' ${i2} | bc -l)" -eq 1 ]
          then
	  val2=`echo "${a}*e(${c}*l(${val1}+${b}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat

       elif ( [[ "$(echo ${val1} '>=' ${i2} | bc -l)" -eq 1 ]] && [[ "$(echo ${val1} '<' ${i22} | bc -l)" -eq 1 ]] )
          then
   	  val2=`echo "${a1}*e(${c1}*l(${val1}+${b1}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat

       elif ( [[ "$(echo ${val1} '>=' ${i22} | bc -l)" -eq 1 ]] && [[ "$(echo ${val1} '<' ${i23} | bc -l)" -eq 1 ]] )
          then
	  val2=`echo "${a2}*e(${c2}*l(${val1}+${b2}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat

       else
	  val2=`echo "${a3}*e(${c3}*l(${val1}+${b3}))" | bc -l`
	  echo "$val1 $val2" > ${DIRMP}psc${ID}.tmp
	  awk '{ printf ("%.2f %.3f\n", $1, $2)}' ${DIRMP}psc${ID}.tmp > ${DIRMP}psc${ID}.dat
       fi
       maxl=`echo ${i24} ${maxll} | awk -v h=${i24} -v g=${maxll} '{if (h > g) print h; else print g}'`
         { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}sc.png\"
		set title \"Stazione di ${nome} - Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; a1=${a1}; b1=${b1}; c1=${c1}; a2=${a2}; b2=${b2}; c2=${c2}; a3=${a3}; b3=${b3}; c3=${c3}\"
		set grid lt 0 lw 1
		unset key
	 	set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a3}*(${maxl}+${b3})**${c3}]
		set y2range [0:${a3}*(${maxl}+${b3})**${c3}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<${i22} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, ${i22}<=x && x<${i23} ? ${a2}*(x+(${b2}))**${c2} : 1/0 axes x1y1, ${i23}<=x && x<=${maxl} ? ${a3}*(x+(${b3}))**${c3} : 1/0 axes x1y1, \"${DIRMP}gaug${ID}.tmp\" u 3:4 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"${DIRMP}gaug${ID}.tmp\" u (\$3):(\$4+2):2 with labels  rotate left axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputsc${nome}.txt
		gnuplot ${DIRMP}inputsc${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}scnm.png\"
		set title \"Stazione di ${nome} \n Scala valida dal ${datav} \n a=${a}; b=${b}; c=${c}; per ${i1}<=H[m]<=${i2} \n a1=${a1}; b1=${b1}; c1=${c1} per ${i11}<H[m]<=${i22} \n a2=${a2}; b2=${b2}; c2=${c2} per ${i13}<H[m]<=${i23} \n a3=${a3}; b3=${b3}; c3=${c3} per ${i14}<H[m]<=${i24} \n valore del ${fuffa1} alle ${fuffa2}\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"Livello [m]\"
		set y2tics nomirror
		#set yrange [0:2500]
		set xrange [${i1}:${maxl}]
		set yrange [0:${a3}*(${maxl}+${b3})**${c3}]
		set y2range [0:${a3}*(${maxl}+${b3})**${c3}]
		set ylabel \"Portata attuale [mc/s]\"
		set y2label \"Portata [mc/s]\"
		set xtics nomirror
		set arrow from ${i1},0 to ${i1},(${a}*(${i1}+${b})**${c}) 
		set arrow from ${i24},0 to ${i24},(${a3}*(${i24}+${b3})**${c3})
		set pointsize 0.8
		set sample 1025
		#set autoscale y
		plot x<${i2} ? ${a}*(x+${b})**${c} : 1/0 axes x1y1, ${i2}<=x && x<${i22} ? ${a1}*(x+(${b1}))**${c1} : 1/0 axes x1y1, ${i22}<=x && x<${i23} ? ${a2}*(x+(${b2}))**${c2} : 1/0 axes x1y1, ${i23}<=x && x<=${maxl} ? ${a3}*(x+(${b3}))**${c3} : 1/0 axes x1y1, \"${DIRMP}psc${ID}.dat\" u 1:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y1, \"${DIRMP}psc${ID}.dat\" u (\$1+0.2):(\$2+0.2):1 with labels axes x1y2, \"${DIRMP}psc${ID}.dat\" u 1:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${DIRMP}inputscnm${nome}.txt
		gnuplot ${DIRMP}inputscnm${nome}.txt

                { 
		echo "set terminal png giant size 950,666
		set output \"${DIRJPG}${ID}Q.png\"
		set title \"Stazione di ${nome}\n Livelli e Portate ultimi 7 giorni (dati non validati)\"
		unset grid
		set y2tics 0.1
		set y2tics nomirror
		set ytics nomirror
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"Giorno\"
		set ylabel \"Portata [mc/s]\"
		set y2label \"Livello [m]\"
		set xtics nomirror
		set pointsize 0.8
		set yrange [0:${a3}*(${maxl}+${b3})**${c3}]
		set autoscale y2
		plot \"${DIRMP}qdat2.tmp\" u 1:4 with lines lt 1 lw 2 axes x1y1 title \"portata\", \"${DIRMP}qdat2.tmp\" u 1:3 with lines lt 3 lw 2 axes x1y2 title \"livello\""
		} > ${DIRMP}inputsc2${nome}.txt
		gnuplot ${DIRMP}inputsc2${nome}.txt

    fi

    awk -v ID=$ID '{ if ( $2 < 10 ) printf "%.0f %s %.1f %s\n", ID,$1,$2,"-"; else printf "%.0f %s %.0f %s\n", ID,$1,$2,"-" }' ${DIRMP}psc${ID}.dat > ${DIRMP}psc${ID}.dat1
done
cat ${DIRMP}*.dat1 | sort > ${DIRMP}qh.dat
cat ${DIRMP}mp_inputdum.txt | sort > ${DIRMP}mp.dat
#join ${DIRMP}mp.dat ${DIRMP}qh.dat | awk '{print $0}' > ${DIRMP}qhinput.tmp
awk 'NR==FNR {_[$1]=$0; next} $1 in _{print $0,_[$1]}' ${DIRMP}qh.dat ${DIRMP}mp.dat | awk '{print $1,$3,$5,$6,$7,$8,$9,$20,$21,$22}' > ${DIRMP}qhinput.txt
#awk '{print $1,$3,$5,$6,$7,$8,$9,$19,$20}' ${DIRMP}qhinput.tmp > ${DIRMP}qhinput.txt 
cat /home/meteo/scripts/idrotrsoglie/grassinqh.sh | grass -text /home/meteo/grassdata/newLocation/IDRO/ 
rm ${DIRMP}*.tmp ${DIRMP}*.dat ${DIRMP}*.dat1
GRAB=(`grep "GRABIASCA" ${DIRMP}qhinput.txt`)
PTB=(`grep "PTE_BRIOLO" ${DIRMP}qhinput.txt`)
CCORN=(`grep "CAMERATA_CORNEL" ${DIRMP}qhinput.txt`)
PCEN=(`grep "PTE_CENE" ${DIRMP}qhinput.txt`)
CP=(`grep "CAPO_DI_PONTE_I" ${DIRMP}qhinput.txt`)
DF=(`grep "DARFO" ${DIRMP}qhinput.txt`)
CRL=(`grep "CAPRIOLO" ${DIRMP}qhinput.txt`)
HL1=`tail -1 ${DIRDATI}106_R.txt | awk '{print $4}'`
HL=`echo "$HL1/100" | bc -l | awk '{printf "%.2f\n", $0}'`
OL=`tail -1 ${DIRDATI}106_R.txt | awk '{print $3}' | sed 's/:00.000//g'`
DL=`tail -1 ${DIRDATI}106_R.txt | awk '{print $2}'`
HPZB1=`tail -1 ${DIRDATI}104_R.txt | awk '{print $4}'`
HPZB=`echo "$HPZB1/100" | bc -l | awk '{printf "%.2f\n", $0}'`
OPZB=`tail -1 ${DIRDATI}104_R.txt | awk '{print $3}' | sed 's/:00.000//g'`
DPZB=`tail -1 ${DIRDATI}104_R.txt | awk '{print $2}'`
HSNC1=`tail -1 ${DIRDATI}8385_R.txt | awk '{print $4}'`
HSNC=`echo "$HSNC1/100" | bc -l | awk '{printf "%.2f\n", $0}'`
OSNC=`tail -1 ${DIRDATI}8385_R.txt | awk '{print $3}' | sed 's/:00.000//g'`
DSNC=`tail -1 ${DIRDATI}8385_R.txt | awk '{print $2}'`
sed -e 's/QGSCA/'${GRAB[8]}'/g' ${DIRMP}Pr_BG.txt | sed -e 's/HGSCA/'${GRAB[7]}'/g' | sed -e 's/DATGSCA/'${GRAB[5]}'/g' | sed -e 's/OGSCA/'${GRAB[6]}'/g' | sed -e 's/DATPB/'${PTB[5]}'/g' | sed -e 's/OPB/'${PTB[6]}'/g' | sed -e 's/HPB/'${PTB[7]}'/g' | sed -e 's/DATCC/'${CCORN[5]}'/g' | sed -e 's/OCC/'${CCORN[6]}'/g'  | sed -e 's/QCC/'${CCORN[8]}'/g' | sed -e 's/HCC/'${CCORN[7]}'/g' | sed -e 's/DATPC/'${PCEN[5]}'/g' | sed -e 's/OPC/'${PCEN[6]}'/g' | sed -e 's/QPC/'${PCEN[8]}'/g' | sed -e 's/HPC/'${PCEN[7]}'/g' | sed -e 's/HL/'${HL}'/g' | sed -e 's/HPZB/'${HPZB}'/g' | sed -e 's/ORALENNA/'${OL}'/g' | sed -e 's/OPZB/'${OPZB}'/g' | sed -e 's/DATLENNA/'${DL}'/g' | sed -e 's/DATPZB/'${DPZB}'/g'| sed -e 's/DATCC/'${CCORN[5]}'/g' | sed -e 's/OCP/'${CP[6]}'/g'  | sed -e 's/QCP/'${CP[8]}'/g' | sed -e 's/HCP/'${CP[7]}'/g'| sed -e 's/DATCP/'${CP[5]}'/g' | sed -e 's/ODF/'${DF[6]}'/g'  | sed -e 's/QDF/'${DF[8]}'/g' | sed -e 's/HDF/'${DF[7]}'/g'| sed -e 's/DATDF/'${DF[5]}'/g' | sed -e 's/OCRL/'${CRL[6]}'/g'  | sed -e 's/QCRL/'${CRL[8]}'/g' | sed -e 's/HCRL/'${CRL[7]}'/g'| sed -e 's/DATCRL/'${CRL[5]}'/g'  | sed -e 's/DATSARNICO/'${DSNC}'/g' | sed -e 's/HSARNICO/'${HSNC}'/g'| sed -e 's/ORASARNICO/'${OSNC}'/g' > ${DIRMP}Pr_BG.html
scp ${DIRJPG}*sc*.png idroweb@172.16.1.11:/var/www/idro/manual
scp ${DIRJPG}*Q.png idroweb@172.16.1.11:/var/www/idro/manual
scp ${DIRMP}Pr_BG.html idroweb@172.16.1.11:/var/www/idro/manual
