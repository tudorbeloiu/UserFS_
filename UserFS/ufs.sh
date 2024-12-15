#!/bin/bash

root_dir="/$HOME/rootDirectory"

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

timp_reactualizare=30

while true
do
  adaugare_user
  sleep "$timp_reactualizare"
done &
