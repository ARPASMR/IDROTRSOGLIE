date --date "7 day ago" '+DATE: %d %m %Y %H %M' > /cygdrive/d/grassworks/gb/script/mptime2.tmp
read fuffa day2 mon2 year2 ora2 min2 < /cygdrive/d/grassworks/gb/script/mptime2.tmp
date --date "0 minute ago" '+DATE: %d %m %Y %H %M' > /cygdrive/d/grassworks/gb/script/mptime1.tmp
read fuffa day1 mon1 year1 ora1 min1 < /cygdrive/d/grassworks/gb/script/mptime1.tmp

wc -l /cygdrive/d/grassworks/gb/script/mp/mp_siti.txt > /cygdrive/d/grassworks/gb/script/mp/amp.tmp
read nn fuffa < /cygdrive/d/grassworks/gb/script/mp/amp.tmp
for ((t=1; t<=nn; t++))
do
head -$t /cygdrive/d/grassworks/gb/script/mp/mp_siti.txt | tail -1 > /cygdrive/d/grassworks/gb/script/mp/bmp.tmp
read ID nome X Y bacino < /cygdrive/d/grassworks/gb/script/mp/bmp.tmp

#nome=LODI
#echo "$nome AT 100.00 100 00:00_01/01/2010 00:00_18/11/2013 10 MINUTE INST TIME MONTH PRINT YES M12 LIN 0.0 100.0 0 PNG DEFAULT dur_${nome}.TXT" > flow.prm
#./flow.bat
#rm flow.prm
#mv -f /cygdrive/c/temp/dur_${nome}.TXT /cygdrive/d/grassworks/gb/script/mp
#mv -f /cygdrive/c/temp/*.PNG /cygdrive/d/grassworks/gb/script/mp

#sed -n -e 11,61p /cygdrive/d/grassworks/gb/script/mp/dur_${nome}.TXT | awk '{print $2, $1}' > /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt
	if ( [[ $ID -eq 8105 ]] || [[ $ID -eq 8545 ]] || [[ $ID -eq 8618 ]] )
	then
	echo "R	$ID	${year2}/${mon2}/${day2} ${ora2}:${min2}	${year1}/${mon1}/${day1} ${ora1}:${min1}" > /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
	unix2dos /cygdrive/d/grassworks/gb/script/EstrazioneDati/IN/Richiesta.txt
	/cygdrive/d/grassworks/gb/script/EstrazioneDati/EstrazioneDati.exe
	fi
	dos2unix /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt
tail -1 /cygdrive/d/grassworks/gb/script/EstrazioneDati/OUT/${ID}_R.txt | awk '{ printf "%d %-s %-s %.2f\n", $1, $2, $3, $4/100 }' | sed 's/:00.000//g' > /cygdrive/d/grassworks/gb/script/mp/livd_${nome}.txt
read ID1 data ora liv < /cygdrive/d/grassworks/gb/script/mp/livd_${nome}.txt
echo $liv > /cygdrive/d/grassworks/gb/script/mp/liv_${nome}.txt
awk -v a=$liv '{print $1-a, a, $2, $1}' /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }' > /cygdrive/d/grassworks/gb/script/mp/livf_${nome}.tmp
paste /cygdrive/d/grassworks/gb/script/mp/livf_${nome}.tmp /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt | sort | sed -n -e 1p > /cygdrive/d/grassworks/gb/script/mp/livf1_${nome}.tmp
paste /cygdrive/d/grassworks/gb/script/mp/liv_${nome}.txt /cygdrive/d/grassworks/gb/script/mp/livf1_${nome}.tmp | awk '{print $2, $1, $4, $6}' > /cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt
read aa bb perc cc  < /cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt
grep -e "$nome" /cygdrive/d/grassworks/gb/script/mp/gaugings.txt | awk '{print $1, $4, $10, $11}' | grep "201[123]" > /cygdrive/d/grassworks/gb/script/mp/mp123_$nome.txt
awk '{print $3}' /cygdrive/d/grassworks/gb/script/mp/mp123_$nome.txt > /cygdrive/d/grassworks/gb/script/mp/mpl_$nome.txt
wc -l /cygdrive/d/grassworks/gb/script/mp/mpl_$nome.txt > /cygdrive/d/grassworks/gb/script/mp/t.tmp
read n fuffa < /cygdrive/d/grassworks/gb/script/mp/t.tmp
for ((x=1; x<=n; x++))
do
head -$x /cygdrive/d/grassworks/gb/script/mp/mpl_$nome.txt | tail -1 > /cygdrive/d/grassworks/gb/script/mp/val.tmp
read livm < /cygdrive/d/grassworks/gb/script/mp/val.tmp
awk -v a=$livm '{print $1-a, a, $2, $1}' /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p > /cygdrive/d/grassworks/gb/script/mp/l.tmp
paste /cygdrive/d/grassworks/gb/script/mp/val.tmp /cygdrive/d/grassworks/gb/script/mp/l.tmp | awk '{print $2, $1, $4, $6}' > /cygdrive/d/grassworks/gb/script/mp/livm$x.tmp
cat /cygdrive/d/grassworks/gb/script/mp/livm*.tmp > /cygdrive/d/grassworks/gb/script/mp/livm_$nome.txt
done

min=`sed -n -e 1p /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt | awk '{print $1}'`
max=`awk '{print $1}' /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt | awk '$1>m{m=$1}END{print m}'`
min6=`sed -n -e 1p /cygdrive/d/grassworks/gb/script/mp/durate/cdur6_${nome}.txt | awk '{print $1}'`
max6=`awk '{print $1}' /cygdrive/d/grassworks/gb/script/mp/durate/cdur6_${nome}.txt | awk '$1>m{m=$1}END{print m}'`
rangel=`awk -v max=$max -v min=$min '{print max-min}' /cygdrive/d/grassworks/gb/script/mp/liv_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'`
#difflivlmis=`awk -v l=$liv '{print $1-l}' /cygdrive/d/grassworks/gb/script/mp/mpl_$nome.txt| awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p`
awk -v l=$liv '{print $2-l, $3}' /cygdrive/d/grassworks/gb/script/mp/livm_$nome.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p > /cygdrive/d/grassworks/gb/script/mp/mplp_$nome.txt
read difflivlmis percmis < /cygdrive/d/grassworks/gb/script/mp/mplp_$nome.txt
percrange=`awk -v r=$rangel -v d=$difflivlmis '{printf "%.0f\n", d*100/r}' /cygdrive/d/grassworks/gb/script/mp/liv_${nome}.txt`
#percrangef=`awk -v pl=$perc -v pfm=$percmis '{print pl-pfm}' /cygdrive/d/grassworks/gb/script/mp/liv_${nome}.txt | awk '{for (i=1; i<=NF; i++) if ($i < 0) $i = -$i; print }'| sort | sed -n -e 1p`
percrangef=`echo "$perc-$percmis" | bc -l`
awk '{print $2, $3}' /cygdrive/d/grassworks/gb/script/mp/livm_$nome.txt | sort > mp1.tmp
awk '{print $3, $2}' /cygdrive/d/grassworks/gb/script/mp/mp123_$nome.txt | sort > mp2.tmp 
paste /cygdrive/d/grassworks/gb/script/mp/mp1.tmp /cygdrive/d/grassworks/gb/script/mp/mp2.tmp > /cygdrive/d/grassworks/gb/script/mp/mp$nome.txt
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
		plot \"/cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt\" u 3:2 w p ps 3 lt 5 lc 4 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.txt\" u 2:1 w p ps 3 lt 7 lc 1 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.tmp\" u (\$2+0.1):(\$1+0.2):4 with labels axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.tmp\" u 2:1:yticlabels(1) w p ps 0 axes x1y2"		
		} > /cygdrive/d/grassworks/gb/script/mp/input${nome}.txt
		gnuplot /cygdrive/d/grassworks/gb/script/mp/input${nome}.txt

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
		plot \"/cygdrive/d/grassworks/gb/script/mp/durate/cdur6_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt\" u 3:2 w p ps 3 lt 5 lc 4 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.tmp\" u 2:1 w p ps 3 lt 7 lc 1 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.tmp\" u (\$2+0.1):(\$1+0.1):4 with labels axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/mp$nome.tmp\" u 2:1:yticlabels(1) w p ps 0 axes x1y2"			
		} > /cygdrive/d/grassworks/gb/script/mp/input${nome}.txt
		gnuplot /cygdrive/d/grassworks/gb/script/mp/input${nome}.txt

		#rm /cygdrive/c/grassworks/gb/script/mp/input${nome}.txt

echo "$ID $ID1 $nome $X $Y $bacino $data $ora $perc $rangel $difflivlmis $percmis $percrange $percrange $percrangef $liv" > /cygdrive/d/grassworks/gb/script/mp/gisinput_${nome}.txt

rm /cygdrive/d/grassworks/gb/script/mp/*.tmp /cygdrive/d/grassworks/gb/script/mp/input*.txt /cygdrive/d/grassworks/gb/script/mp/liv*.txt /cygdrive/d/grassworks/gb/script/mp/mp123*.txt /cygdrive/d/grassworks/gb/script/mp/mpl*.txt
done
cat /cygdrive/d/grassworks/gb/script/mp/gisinput*.txt > /cygdrive/d/grassworks/gb/script/mp/mp_input.txt
scp /cygdrive/d/grassworks/scambio/*mp*.png idroweb@172.16.1.11:/var/www/idro/manual
cat /cygdrive/d/grassworks/gb/script/mp/grassinv1.sh | /usr/local/bin/grass62 -text /cygdrive/d/grassworks/gb/MISURE/
rm  /cygdrive/d/grassworks/gb/script/mp/gisinput_*.txt

#plot \"/cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt\" u 3:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livm_${nome}.txt\" u 3:2 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livm_$nome.txt\" u 3:2:yticlabels(2) w p ps 0 axes x1y2"
#plot \"/cygdrive/d/grassworks/gb/script/mp/durate/cdur6_${nome}.txt\" using 2:1 with lines lt 3 lw 3 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livf_${nome}.txt\" u 3:2 w p pt 5 ps 3 lt 8 lc 4 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livm_${nome}.txt\" u 3:2 w p pt 7 ps 3 lt 10 lc 1 axes x1y2, \"/cygdrive/d/grassworks/gb/script/mp/livm_$nome.txt\" u 3:2:yticlabels(2) w p ps 0 axes x1y2"
