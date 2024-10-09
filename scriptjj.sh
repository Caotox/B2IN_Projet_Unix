#!/bin/bash

# exos 2

date=$("%Y-%m-%d") #pour avoir la date du jour sur ce format YYYY-MM-DD
jours_inactifs=$(date -d "$date -7 days") #pour déterminer une période d'inactivité de 7 jours


users_inactifs=$(lastlog -b $jours_inactifs) #pour voir les users inactifs depuis 7 jours

if [ -z $users_inactifs ]; then # -z sert à vérifier si la variable est vide
echo "il n'y a pas d'utilisateurs inactifs"
else
echo "utilisateurs inactifs : $user"
fi;

for user in $users_inactifs; do
    echo "Que souhaitez-vous faire pour l'utilisateur $user ?"
    echo "1) Verrouiller le compte"
    echo "2) Supprimer le compte (le répertoire personnel sera sauvegardé)"
    read -p "Choisissez une option (1, 2) : " reponse_inactivite
case $reponse_inactivite in
        1)
            sudo chage -E 0 $user
            echo "Le compte de $user a été verrouillé."
            ;;
        2)
            user_home_dir=$(getent passwd $user | cut -d: -f6)
            
            if [[ -d "$user_home_dir" ]]; then
                echo "Sauvegarde du répertoire personnel de $user..."
                tar -czf /backup/${user}_home_backup_$(date +%Y%m%d).tar.gz "$user_home_dir"
                echo "Sauvegarde terminée : /backup/${user}_home_backup_$(date +%Y%m%d).tar.gz"
            else
                echo "Le répertoire personnel de $user n'existe pas."
            fi
            sudo userdel -r $user
            echo "Le compte de $user a été supprimé."
            ;;
        *)
            echo "Une erreur s'est produite, veuillez réessayer."
            ;;
esac
done
