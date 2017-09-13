# ABSTRACT
Porting su gagliardo del meccanismo di creazione dei file *png e *jpeg per PIGAL

# PREREQUISITI
tutto viene lanciato dallo script /home/meteo/scripts/runnmarzi.sh, che sostanzialmente setta 
qualche variabile e poi lancia l'eseguibile /home/meteo/bin/nmarzi

gnuplot

# ESECUZIONE
vengono eseguiti in sequenza
* __idrotrsoglie3.sh__  : grafica i livelli e le soglie per 24h e 7gg
* __Q.sh__              : grafica le portate
* __duratempdaiCxcdum1__: grafica le portate dai livelli tramite scale di deflusso

