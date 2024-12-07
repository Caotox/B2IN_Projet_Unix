#!/bin/bash

date=$(date +"%Y-%m-%d") # pour avoir la date du jour au format YYYY-MM-DD

jours_inactifs=90 # définit une période d'inactivité en jours directement (par exemple, 90 jours) car `lastlog -b` accepte un nombre de jours.

users_inactifs=$(lastlog -b $jours_inactifs | awk 'NR>1 {print $1}') # extraction des noms d'utilisateur avec `awk`, en sautant l'en-tête de la commande `lastlog`.

if [ -z "$users_inactifs" ]; then # -z sert à vérifier si la variable est vide
    echo "il n'y a pas d'utilisateurs inactifs"
    exit 0 # arrêter le script si aucun utilisateur inactif n'est détecté
else
    echo "utilisateurs inactifs :"
    echo "$users_inactifs" # afficher la liste des utilisateurs détectés comme inactifs
fi

# vérifier ou créer le répertoire de sauvegarde, le répertoire `/backup` est utilisé pour stocker les sauvegardes des répertoires personnels des utilisateurs supprimés.
backup_dir="/backup"
mkdir -p "$backup_dir" # Création du répertoire si nécessaire

# tentative d'une alerte par mail
for user in $users_inactifs; do
    user_email="$user@example.com"  # Remplacez par le domaine de l'entreprise
    echo "Cher $user, 
Votre compte est inactif depuis plus de $jours_inactifs jours. 
Veuillez vous connecter pour éviter que votre compte ne soit verrouillé ou supprimé." | mail -s "Alerte d'inactivité" $user_email

    # interactivité pour gérer les utilisateurs inactifs
    echo "Que souhaitez-vous faire pour l'utilisateur $user ?"
    echo "1) Verrouiller le compte"
    echo "2) Supprimer le compte (le répertoire personnel sera sauvegardé)"
    read -p "Choisissez une option (1 ou 2) : " reponse_inactivite

    # utilisation de case pour traiter les choix de l'administrateur
    case $reponse_inactivite in
        1)
            sudo chage -E 0 $user             #  Chage verrouille le compte du user au bout de 0 jour (donc instantanément)
            echo "Le compte de $user a été verrouillé."
            ;;
        2)
            # récupérer le répertoire personnel de l'utilisateur
            user_home_dir=$(getent passwd $user | cut -d: -f6) # getent pour obtenir les informations de l'utilisateur, cut pour séparer les champs avec le délimiteur :, -f pour spécifier le champ
            
            # vérifier que le répertoire personnel de l'utilisateur existe avant de le sauvegarder
            if [[ -d "$user_home_dir" ]]; then # -d pour vérifier que le répertoire existe
                tar -czf "$backup_dir/${user}_backup.tar.gz" "$user_home_dir" # pour compresser le répertoire personnel de l'utilisateur et le save, czf = c create, z compress, f file (indiquer le nom de l'archive)
                echo "Répertoire personnel de $user sauvegardé dans $backup_dir."
            else
                echo "Répertoire personnel de $user introuvable. Aucune sauvegarde effectuée."
            fi

            # supprimer le compte
            sudo userdel -r $user
            echo "Le compte de $user a été supprimé."
            ;;
        *)
            # message d'erreur pour les options non valides
            echo "Option invalide. Aucune action effectuée pour $user."
            ;;
    esac
done

