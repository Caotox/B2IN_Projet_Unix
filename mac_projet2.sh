#!/bin/bash
# exo 1 - Adapté pour macOS

fichier="Names.txt"
declare -a tableau_indi
var_indice=0

# Lire le fichier pour remplir le tableau
while read -r line; do
    tableau_indi[$var_indice]="$line"
    var_indice=$((var_indice + 1))
done < "$fichier"

echo "Liste des utilisateurs : ${tableau_indi[@]}"

longueur_tab=${#tableau_indi[@]}
longueur_tab=$((longueur_tab / 4))
ecart_tabl=0

# Boucle pour créer ou modifier les utilisateurs
for ((i=0; i<longueur_tab; i++)); do
    PASSWORD=$(openssl rand -base64 12)
    echo "Votre mot de passe est : $PASSWORD"

    user=${tableau_indi[0 + ecart_tabl]}
    group=${tableau_indi[1 + ecart_tabl]}
    shell=${tableau_indi[2 + ecart_tabl]}
    rep=${tableau_indi[3 + ecart_tabl]}

    # Créer le groupe s'il n'existe pas
    if ! dscl . -list /Groups | grep -q "^$group$"; then
        sudo dscl . -create /Groups/"$group"
    fi

    # Créer ou modifier l'utilisateur
    if dscl . -list /Users | grep -q "^$user$"; then
        sudo dscl . -create /Users/"$user" UserShell "$shell"
        sudo dscl . -create /Users/"$user" NFSHomeDirectory "$rep"
        sudo dscl . -append /Groups/"$group" GroupMembership "$user"
    else
        sudo dscl . -create /Users/"$user"
        sudo dscl . -create /Users/"$user" UserShell "$shell"
        sudo dscl . -create /Users/"$user" NFSHomeDirectory "$rep"
        sudo dscl . -append /Groups/"$group" GroupMembership "$user"
    fi

    # Définir le mot de passe
    echo "$PASSWORD" | sudo dscl . -passwd /Users/"$user" -

    # Créer le répertoire personnel s'il n'existe pas
    if [ ! -d "$rep" ]; then
        sudo mkdir -p "$rep"
        sudo chown "$user":"$group" "$rep"
    fi

    ecart_tabl=$((ecart_tabl + 4))
done

# Vérifier les utilisateurs inactifs
date=$(date +"%Y-%m-%d")
jours_inactifs=90 # Période d'inactivité en jours
inactive_users=$(dscl . list /Users LastName | awk -v days="$jours_inactifs" \
'BEGIN { cutoff = systime() - (days * 86400) }
{ if ($2 != "" && ($3 < cutoff)) print $1 }')

if [ -z "$inactive_users" ]; then
    echo "Il n'y a pas d'utilisateurs inactifs."
    exit 0
else
    echo "Utilisateurs inactifs :"
    echo "$inactive_users"
fi

backup_dir="/backup"
mkdir -p "$backup_dir"

# Gestion des utilisateurs inactifs
for user in $inactive_users; do
    echo "Que souhaitez-vous faire pour l'utilisateur $user ?"
    echo "1) Verrouiller le compte"
    echo "2) Supprimer le compte (le répertoire personnel sera sauvegardé)"
    read -p "Choisissez une option (1 ou 2) : " reponse_inactivite

    case $reponse_inactivite in
        1)
            sudo dscl . -create /Users/"$user" UserShell /usr/bin/false
            echo "Le compte de $user a été verrouillé."
            ;;
        2)
            user_home_dir=$(dscl . -read /Users/"$user" NFSHomeDirectory | awk '{print $2}')
            if [[ -d "$user_home_dir" ]]; then
                sudo tar -czf "$backup_dir/${user}_backup.tar.gz" "$user_home_dir"
                echo "Répertoire personnel de $user sauvegardé dans $backup_dir."
            else
                echo "Répertoire personnel de $user introuvable. Aucune sauvegarde effectuée."
            fi

            sudo dscl . -delete /Users/"$user"
            echo "Le compte de $user a été supprimé."
            ;;
        *)
            echo "Option invalide. Aucune action effectuée pour $user."
            ;;
    esac
done

# Gestion des ACLs pour les répertoires
repertoire_rh="/path/to/rh_directory" # Modifiez les chemins
repertoire_direction="/path/to/direction_directory"

groupe_rh="RH"
groupe_direction="CEO"

sudo chmod +a "group:$groupe_rh allow read" "$repertoire_rh"
sudo chmod +a "group:$groupe_direction allow read,write" "$repertoire_direction"

echo "ACL sur le répertoire RH :"
sudo ls -le "$repertoire_rh"

echo "ACL sur le répertoire CEO :"
sudo ls -le "$repertoire_direction"
