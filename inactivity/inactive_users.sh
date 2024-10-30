#!/bin/bash

date=$("%Y-%m-%d") #pour avoir la date du jour sur ce format YYYY-MM-DD
jours_inactifs=$(date -d "$date -7 days") #pour déterminer une période d'inactivité de 7 jours


users_inactifs=$(lastlog -b $jours_inactifs) #pour voir les users inactifs depuis 7 jours

if [ -z $users_inactifs ]; then # -z sert à vérifier si la variable est vide
echo "il n'y a pas d'utilisateurs inactifs"
else
echo "utilisateurs inactifs : $user"
fi;

#tentative d'une alerte par mail
user_email="$user@example.com"  # Remplacez par le domaine de votre entreprise ou système
    echo "Cher $user, 
Votre compte est inactif depuis plus de $jours_inactifs jours. 
Veuillez vous connecter pour éviter que votre compte ne soit verrouillé ou supprimé." | mail -s "Alerte d'inactivité" $user_email

for user in $users_inactifs; do
    echo "Que souhaitez-vous faire pour l'utilisateur $user ?"
    echo "1) Verrouiller le compte"
    echo "2) Supprimer le compte (le répertoire personnel sera sauvegardé)"
    read -p "Choisissez une option (1, 2) : " reponse_inactivite
    case $reponse_inactivite in
            1)
                sudo chage -E 0 $user #verrouille le compte du user au bout de 0 jour (donc instantanément)
                ;;
            2)
                user_home_dir=$(getent passwd $user | cut -d: -f6) #getent pour obtenir les informations de l'utilisateur
                
                if [[ -d "$user_home_dir" ]]; then #-d pour vérifier que le répertoire existe
                    tar -czf /backup/${user}_backup.tar.gz "$user_home_dir" #pour compresser le répertoire personnel de l'utilisateur et le save
                fi
                sudo userdel -r $user #supprimer le compte
                ;;
            *)
                echo "Une erreur s'est produite, veuillez réessayer."
                ;;
    esac
done
