date --date "7 day ago" '+DATE: %d %m %Y %H %M' > /cygdrive/d/grassworks/gb/script/mptime2.tmp
read fuffa day2 mon2 year2 ora2 min2 < /cygdrive/d/grassworks/gb/script/mptime2.tmp
date --date "0 minute ago" '+DATE: %d %m %Y %H %M' > /cygdrive/d/grassworks/gb/script/mptime1.tmp
read fuffa day1 mon1 year1 ora1 min1 < /cygdrive/d/grassworks/gb/script/mptime1.tmp
d=/cygdrive/d/grassworks/gb/script/mp/
wc -l ${d}mp_siti.txt > ${d}amp.tmp
read nn fuffa < ${d}amp.tmp
for ((t=1; t<=nn; t++))
do
head -$t ${d}mp_siti.txt | tail -1 > ${d}bmp.tmp
read ID nome X Y bacino < ${d}bmp.tmp

#nome=LODI
#echo "$nome AT 100.00 100 00:00_01/01/2010 00:00_18/11/2013 10 MINUTE INST TIME MONTH PRINT YES M12 LIN 0.0 100.0 0 PNG DEFAULT dur_${nome}.TXT" > flow.prm
#./flow.bat
#rm flow.prm
#mv -f /cygdrive/c/temp/dur_${nome}.TXT /cygdrive/d/grassworks/gb/script/mp
#mv -f /cygdrive/c/temp/*.PNG /cygdrive/d/grassworks/gb/script/mp

#sed -n -e 11,61p ${d}dur_${nome}.TXT | awk '{print $2, $1}' > ${d}durate/cdur_${nome}.txt
	if ( [[ $ID -eq 8545 ]] || [[ $ID -eq 8618 ]] )
	then
	echo "R	$ID	${year2}/${mon2}/${day2} ${ora2}:${min2}	${year1}/${mon1}/${day1} ${ora1}:${min1}" > /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
	unix2dos /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
	/cygdrive/d/grassworks/gb/script/EstrazioneDati/EstrazioneDati.exe
	tail -144 /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt > /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_24R.txt

		yy=`awk '$4>m{m=$4}END{print m}' /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt`
		int=`echo ${yy} | bc -l | xargs printf "%1.0f"`
		let yyy=${int}+30
		{ 
		echo "set terminal png giant size 950,666
		set output \"/cygdrive/d/grassworks/scambio/${ID}.jpeg\"
		set title \"${bac} - Stazione di ${nome} (dati non validati) - 7g\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"/cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt\" using 2:4 with lines lt 3 lw 3"
		} > /cygdrive/d/grassworks/gb/script/input${ID}.txt
		gnuplot /cygdrive/d/grassworks/gb/script/input${ID}.txt
		rm /cygdrive/d/grassworks/gb/script/input${ID}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"/cygdrive/d/grassworks/scambio/${ID}_24.jpeg\"
		set title \"${bac} - Stazione di ${nome} (dati non validati) - 24h\"
		set grid
		unset key
		set xdata time
		set timefmt \"%Y-%m-%d %H:%M\"
		set format x \"%H:%M\n%d/%m\"
		set xlabel \"giorno\"
		set ylabel \"livello idrometrico (cm)\"
		set pointsize 0.8
		set yrange [:'$yyy']
		plot \"/cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_24R.txt\" using 2:4 with lines lt 3 lw 3"
		} > /cygdrive/d/grassworks/gb/script/input24_${ID}.txt
		gnuplot /cygdrive/d/grassworks/gb/script/input24_${ID}.txt
		rm /cygdrive/d/grassworks/gb/script/input24_${ID}.txt

	fi
	dos2unix /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt
if ( [[ $ID -eq 3002 ]] || [[ $ID -eq 3032 ]]  || [[ $ID -eq 3092 ]] )
	then
dos2unix /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/${ID}_R.txt
tail -3 /cygdrive/d/grassworks/gb/script/EstrazioneDati2/OUT/${ID}_R.txt | head -1 | awk '{ printf "%d %-s %-s %.2f\n", $1, $2, $3, $4/100 }' | sed 's/:00.000//g' > ${d}livd_${nome}.txt
else
tail -1 /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt | awk '{ printf "%d %-s %-s %.2f\n", $1, $2, $3, $4/100 }' | sed 's/:00.000//g' > ${d}livd_${nome}.txt
fi
read ID1 data ora liv < ${d}livd_${nome}.txt
echo $liv > ${d}liv_${nome}.txt
awk -v a=$liv '{print $1-a, a, $2, $1}' ${d}durate/cdur_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }' > ${d}livf_${nome}.tmp
paste ${d}livf_${nome}.tmp ${d}durate/cdur_${nome}.txt | sort | sed -n -e 1p > ${d}livf1_${nome}.tmp
paste ${d}liv_${nome}.txt ${d}livf1_${nome}.tmp | awk '{print $2, $1, $4, $6}' > ${d}livf_${nome}.txt
read aa bb perc cc  < ${d}livf_${nome}.txt
grep -e "$nome" ${d}gaugings.txt | awk '{print $1, $4, $10, $11}' | grep "201[34]" > ${d}mp123_$nome.txt
awk '{print $3}' ${d}mp123_$nome.txt > ${d}mpl_$nome.txt
wc -l ${d}mpl_$nome.txt > ${d}t.tmp
read n fuffa < ${d}t.tmp
for ((x=1; x<=n; x++))
do
head -$x ${d}mpl_$nome.txt | tail -1 > ${d}val.tmp
read livm < ${d}val.tmp
awk -v a=$livm '{print $1-a, a, $2, $1}' ${d}durate/cdur_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p > ${d}l.tmp
paste ${d}val.tmp ${d}l.tmp | awk '{print $2, $1, $4, $6}' > ${d}livmm$x.tmp
cat ${d}livmm*.tmp > ${d}livm_$nome.txt
done

min=`sed -n -e 1p ${d}durate/cdur_${nome}.txt | awk '{print $1}'`
max=`awk '{print $1}' ${d}durate/cdur_${nome}.txt | awk '$1>m{m=$1}END{print m}'`
min6=`sed -n -e 1p ${d}durate/cdur6_${nome}.txt | awk '{print $1}'`
max6=`awk '{print $1}' ${d}durate/cdur6_${nome}.txt | awk '$1>m{m=$1}END{print m}'`
rangel=`awk -v max=$max -v min=$min '{print max-min}' ${d}liv_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'`
#difflivlmis=`awk -v l=$liv '{print $1-l}' ${d}mpl_$nome.txt| awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p`
awk -v l=$liv '{print $2-l, $3}' ${d}livm_$nome.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p > ${d}mplp_$nome.txt
read difflivlmis percmis < ${d}mplp_$nome.txt
percrange=`awk -v r=$rangel -v d=$difflivlmis '{printf "%.0f\n", d*100/r}' ${d}liv_${nome}.txt`
#percrangef=`awk -v pl=$perc -v pfm=$percmis '{print pl-pfm}' ${d}liv_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p`
percrangef=`echo "$perc-$percmis" | bc -l | awk '{ if($1>=0) { print $1} else { print $1*-1}}'`
lung=`echo "scale=5;sqrt(${percrange}^2+${percrangef}^2)" | bc -l`
awk '{print $2, $3}' ${d}livm_$nome.txt | sort > ${d}mp1.tmp
awk '{print $3, $2}' ${d}mp123_$nome.txt | sort > ${d}mp2.tmp 
paste ${d}mp1.tmp ${d}mp2.tmp | sed 's/\t/ /g' > ${d}mp${nome}.tmp
cp ${d}mp${nome}.tmp ${d}cdate/mp${nome}.tmp
		{ 
		echo "set terminal png giant size 950,666
		set output \"/cygdrive/d/grassworks/scambio/${ID}mp.png\"
		set title \"Stazione di ${nome} - CD 0-100\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"frequenza\"
		#set x2label \"portata misure\"
		set ylabel \"livello misure\"
		set y2label \"livelli\"
		set y2tics nomirror
		#set ytics nomirror
		#set x2tics nomirror
		set xtics nomirror
		set pointsize 0.8
		set yrange [$min:$max]
		set y2range [$min:$max]
		set autoscale x
		#set autoscale x2
		plot \"${d}durate/cdur_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \
		 \"${d}livf_${nome}.txt\" u 3:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y2, \
		 \"${d}livf_${nome}.txt\" u 3:2:2 with labels offset 4 axes x1y2, \
		 \"${d}mp$nome.tmp\" u (\$2+0.1):(\$1+0.2):4 with labels axes x1y2, \
		 \"${d}livm_${nome}.txt\" u 3:2 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \
		 \"${d}livm_$nome.txt\" u 3:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${d}input${nome}.txt
		gnuplot ${d}input${nome}.txt

		{ 
		echo "set terminal png giant size 950,666
		set output \"/cygdrive/d/grassworks/scambio/${ID}mp6.png\"
		set title \"Stazione di ${nome} - CD 6-100\"
		set grid lt 0 lw 1
		unset key
		set xlabel \"frequenza\"
		#set x2label \"portata misure\"
		set ylabel \"livello misure\"
		set y2label \"livelli\"
		set y2tics nomirror
		#set ytics nomirror
		#set x2tics nomirror
		set xtics nomirror
		set pointsize 0.8
		set xrange [6:*]
		set yrange [$min6:$max6]
		set y2range [$min6:$max6]
		#set autoscale x
		#set autoscale x2
		plot \"${d}durate/cdur6_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \
		 \"${d}livf_${nome}.txt\" u 3:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y2, \
		 \"${d}livf_${nome}.txt\" u 3:2:2 with labels offset 4 axes x1y2, \
		 \"${d}mp${nome}.tmp\" u (\$2+0.1):(\$1+0.07):4 with labels axes x1y2, \
		 \"${d}livm_${nome}.txt\" u 3:2 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \
		 \"${d}livm_$nome.txt\" u 3:2:yticlabels(2) w p ps 0 axes x1y2"
		} > ${d}input${nome}.txt
		gnuplot ${d}input${nome}.txt

		#rm /cygdrive/c/grassworks/gb/script/mp/input${nome}.txt

echo "$ID $ID1 $nome $X $Y $bacino $data $ora $perc $rangel $difflivlmis $percmis $percrange $percrangef $lung $liv $liv" > ${d}gisinput_${nome}.txt

rm ${d}*.tmp ${d}input*.txt ${d}liv*.txt ${d}mp123*.txt ${d}mpl*.txt
done
cat ${d}gisinput*.txt > ${d}mp_input.txt
scp /cygdrive/d/grassworks/scambio/*mp*.png idroweb@172.16.1.11:/var/www/idro/manual
cat ${d}grassin.sh | /usr/local/bin/grass62 -text /cygdrive/d/grassworks/gb/MISURE/
rm  ${d}gisinput_*.txt

${d}sc.sh
