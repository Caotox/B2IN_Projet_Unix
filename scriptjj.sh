# exos 2

jours_inactifs=7

date=`Date`

users_inactifs=$(lastlog -b $jours_inactifs)

if [user = $users_inactifs]; then
echo "votre compte a été détecté comme étant inactif depuis plus de 7 jours"
fi

for user in $users_inactifs; do
    echo "souhaitez vous verrouillez ou supprimer ce compte ?"
    read reponse_inactivite
    if [$reponse_inactivite="supprimer"]; then
    userdel $users_inactifs
    else
    echo "le compte n'a pas été supprimé"
    fi;
done;
