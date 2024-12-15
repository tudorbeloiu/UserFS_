#!/bin/bash

root_dir="/$HOME/rootDirectory"
raport_zilnic="$rootdir/raport.txt"

read -p "Numarul de procese cele mai active: " num

if [[ -z "$num" ]]
then
  echo "Mod de utilizare: Introdu un numar valid format doar din cifre de la 0 la 9"
  exit 1
fi


if ! [[ "$num" =~ ^[0-9]+$ ]]
then
  echo "Eroare! Numarul specificat nu este corect!"
  echo "Mod de utilizare: Introdu un numar valid format doar din cifre de la 0 la 9"
  exit 1
fi




read -p "Numarul de procese pentru care un utilizator devine suspicios: " numproc

if [[ -z "$numproc" ]]
then
  echo "Mod de utilizare: Introdu un numar valid format doar din cifre de la 0 la 9"
  exit 1
fi

if ! [[ "$numproc" =~ ^[0-9]+$ ]]
then
  echo "Eroare! Numarul specificat nu este corect!"
  echo "Mod de utilizare: Introdu un numar valid format doar din cifre de la 0 la 9"
  exit 1
fi



adaugare_user(){
   mkdir -p "$root_dir"

   utilizatori_activi=$(who | awk '{print $1}' | sort | uniq)

   for user_directory in "$root_dir"/*
   do
      if [[ -d "$user_directory" ]]
      then
         utilizator=$(basename "$user_directory")
         if ! echo "$utilizatori_activi" | grep -q "$utilizator"
         then
            echo "" > "$user_directory/procs"
            date > "$user_directory/lastlogin"
         fi
      fi
   done

   for user in "$utilizatori_activi"
   do
     user_directory="$root_dir/$user"
     mkdir -p "$user_directory"
     ps -u "$user" > "$user_directory/procs"
   done
}

generare_raport(){
   contor=0
   utilizatori_activi=$(who | awk '${print $1}' | sort | uniq)
   for activ in "$utilizatori_activi"
   do
     ((contor++))
   done
   #echo $contor
   most_procese_utilizate=$(ps aux | awk '${print $11}' | sort | uniq -c | sort -nr | head -n $num)
   most_utilizatori_activi=$(ps aux | awk '${print $1}' | sort | uniq -c | sort -nr | head -n $num)

   echo "Raportul UserFS in data de: $(date)" > "$raport_zilnic"
   echo "---------------------------------------"
   echo "Numarul total de utilizatori activi astazi: $contor" > "$raport_zilnic"
   echo "Utilizatorii activi astazi: " > "$raport_zilnic"
   echo "$utilizatori_activi" > "$raport_zilnic"
   echo "---------------------------------------"
   echo "Cele mai utilizate procese astazi: " > "$raport_zilnic"
   echo "$most_procese_utilizate" > "$raport_zilnic"
   echo "---------------------------------------"
   echo "Cei mai activi utilizatori astazi: " > "$raport_zilnic"
   echo "$most_utilizatori_activi" > "$raport_zilnic"
   echo "---------------------------------------"
   echo "---------------------------------------"

   echo "Utilizatori suspiciosi: " > "$raport_zilnic"

   for user_directory in "$root_dir"/*
   do
      if [[ -d "$user_directory" ]]
      then
        utilizator=$(basename "$user_directory")
        cnt_procese_user=$(cat "$user_directory/procs" | wc -l)
        if [[ "$cnt_procese_user" -gt "$numproc" ]]
        then
          echo "$utilizator are $cnt_procese_user active" > "$raport_zilnic"
        fi
      fi
   done
}

timp_reactualizare=30

while true
do
  adaugare_user
  sleep "$timp_reactualizare"
done &


while true
do
  ora=$(date +"%H:%M")
  if [[ "$ora" == "00:00" ]]
  then
    generare_raport
    sleep 60
  fi
  sleep 30
done
