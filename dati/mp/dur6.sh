wc -l /cygdrive/d/grassworks/gb/script/mp/mp_siti.txt > /cygdrive/d/grassworks/gb/script/mp/amp.tmp
read nn fuffa < /cygdrive/d/grassworks/gb/script/mp/amp.tmp
for ((t=1; t<=nn; t++))
do
head -$t /cygdrive/d/grassworks/gb/script/mp/mp_siti.txt | tail -1 > /cygdrive/d/grassworks/gb/script/mp/bmp.tmp
read ID nome X Y bacino < /cygdrive/d/grassworks/gb/script/mp/bmp.tmp
sed -n -e 1,48p /cygdrive/d/grassworks/gb/script/mp/durate/cdur_${nome}.txt > /cygdrive/d/grassworks/gb/script/mp/durate/cdur6_$nome.txt
done
rm amp.tmp bmp.tmp
