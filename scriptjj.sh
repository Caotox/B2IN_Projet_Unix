#!/bin/bash

# exos 2
# connexion à un user pour qu'on puisse voir qui est supposément inactif
# ou plutôt créer une boucle pour voir si dans la liste des users il y en a des inactifs

#refaire le truc pour la date et tout pour que ça fasse la date du j - 7j pour que ça soit déclaré comme inactif
#cependant le truc de date là ne marche pas car ça donne une chaîne de caractères et non une date
#donc si je fais -7 ça va rien rendre

date=`Date`
jours_inactifs=$date-7

users_inactifs=$(lastlog -b $jours_inactifs)

if [ -z $users_inactifs ]; then
echo "il n'y a pas d'utilisateurs inactifs"
else
echo "votre compte a été détecté comme étant inactif depuis plus de 7 jours"
fi;

for user in $users_inactifs; do
    echo "souhaitez vous verrouillez ou supprimer ce compte ?"
    read reponse_inactivite
    if [$reponse_inactivite="supprimer"]; then
    userdel $users_inactifs
    else
    echo "le compte n'a pas été supprimé"
    fi;
done;
