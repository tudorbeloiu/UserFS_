#!/bin/bash

root_dir="$HOME/rootDirectory"
raport="$HOME/dailyReport"

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
   mkdir -p "$raport"
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

   for user in "$utilizatori_activi"
   do
     user_directory="$root_dir/$user"
     mkdir -p "$user_directory"

     if [[ ! -f "$user_directory/all_procs" ]]; then
        echo "Creare fisier all_procs pentru $user"
        echo "" > "$user_directory/all_procs"
     fi

     current_procs=$(ps -u "$user" -o comm=)
     echo "$current_procs" | sort | uniq -c | sort -n > "$user_directory/current_procs_count"


     if [[ -f "$user_directory/all_procs" ]]; then
        cat "$user_directory/all_procs" | sort > "$user_directory/existing_sorted"
     else
        echo "" > "$user_directory/existing_sorted"
     fi

     comm -23 <(sort "$user_directory/current_procs_count") <(sort "$user_directory/existing_sorted") > "$user_directory/new_procs"


     if [[ -s "$user_directory/new_procs" ]]; then
        cat "$user_directory/new_procs" >> "$user_directory/all_procs"
     fi

     sort -u "$user_directory/all_procs" -o "$user_directory/all_procs"
     rm -f "$user_directory/existing_sorted" "$user_directory/new_procs" "$user_directory/current_procs_count"

   done
}

generare_raport(){
   mkdir -p "$raport"
   zi_crt=$(date +"%Y-%m-%d")
   echo "Raportul pentru ziua $zi_crt " > "$raport/raport_zilnic"
   echo "------------------------------" >> "$raport/raport_zilnic"

   counter=0
   for user_directory in "$root_dir"/*
   do
      counter=$((counter+1))
   done
   echo "Numarul de utilizatori activi: $counter " >> "$raport/raport_zilnic"

}


while true
do
  adaugare_user
  sleep 30
done &


while true
do
  ora=$(date +"%H:%M")
  if [[ "$ora" == "13:12" ]]
  then
    generare_raport
    sleep 60
  fi
  sleep 50
done &
