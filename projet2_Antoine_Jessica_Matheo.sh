#!/bin/bash
# exo 1

fichier="Names.txt"
declare -a tableau_indi
var_indice=0

while read line; do
    tableau_indi[$var_indice]="$line"
    var_indice=$((var_indice + 1))
done < "$fichier"

echo "Liste des utilisateurs : ${tableau_indi[@]}"

longueur_tab=${#tableau_indi[@]}
longueur_tab=$((longueur_tab / 4))
ecart_tabl=0

for ((i=0; i<longueur_tab; i++)); do
    PASSWORD=$(openssl rand -base64 12)
    echo "Votre mot de passe est : $PASSWORD"

    user=${tableau_indi[0 + ecart_tabl]}
    group=${tableau_indi[1 + ecart_tabl]}
    shell=${tableau_indi[2 + ecart_tabl]}
    rep=${tableau_indi[3 + ecart_tabl]}

    if ! getent group "$group" >/dev/null; then
        groupadd "$group"
    fi

    if getent passwd "$user" >/dev/null; then
        usermod -g "$group" -s "$shell" -d "$rep" "$user"
    else
        useradd -m -g "$group" -s "$shell" -d "$rep" "$user"
    fi

    echo "$user:$PASSWORD" | chpasswd
    chage -M 30 "$user"

    ecart_tabl=$((ecart_tabl + 4))
done


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


repertoire_rh="/../../rh_directory" #faire des chemins pour les répertoires RH et Direction
repertoire_direction="/../t../direction_directory"

groupe_rh="RH" #voir avec matheo les groupes qu'il aura créés => il faut qu'il corrige en fonction de ses groupes
groupe_direction="CEO"

setfacl -m g:$groupe_rh:r-- $repertoire_rh #lecture seule pour leur répertoire

setfacl -d -m g:$groupe_rh:r-- $repertoire_rh #lecture seule par défaut


setfacl -m g:$groupe_direction:rw- $repertoire_direction #lecture et écriture pour leur répertoire

setfacl -d -m g:$groupe_direction:rw- $repertoire_direction #lecture et écriture par défaut


echo "ACL sur le répertoire RH :"
getfacl $repertoire_rh

echo "ACL sur le répertoire CEO :"
getfacl $repertoire_direction

#à voir en fonction qui aura quelles perm sur quels répertoires mais je fais avec ce que je peux pour l'instant