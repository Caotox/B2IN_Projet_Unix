#!/bin/bash

# exos 2

date=$("%Y-%m-%d") #pour avoir la date du jour sur ce format YYYY-MM-DD
jours_inactifs=$(date -d "$date -7 days") #pour déterminer une période d'inactivité de 7 jours


users_inactifs=$(lastlog -b $jours_inactifs) #pour voir les users inactifs depuis 7 jours

if [ -z $users_inactifs ]; then # -z sert à vérifier si la variable est vide
echo "il n'y a pas d'utilisateurs inactifs"
else
echo "votre compte a été détecté comme étant inactif depuis plus de 7 jours"
fi;

for user in $users_inactifs; do
    echo "souhaitez vous verrouillez ou supprimer ce compte ?"
    read reponse_inactivite
    if [$reponse_inactivite="supprimer"]; then
    sauvegarder $users_inactifs && userdel $users_inactifs
    else
    echo "le compte n'a pas été supprimé"
    fi;
done;
