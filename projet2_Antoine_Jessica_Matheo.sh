#!/bin/bash
# exo 1

fichier="Names.txt"

if [[ ! -f "$fichier" || ! -s "$fichier" ]]; then
    echo "Erreur : Le fichier '$fichier' est introuvable ou vide."
    exit 1
fi

declare -a tableau_indi # création du tableau
var_indice=0 # on commence à l'indice 0

while IFS= read -r line || [[ -n "$line" ]]; do # IFS= pour éviter la suppression des espaces en début et fin de ligne (en gros ça fait en sorte que ça traite 1 ligne comme 1 seule chaine de texte)
    tableau_indi[$var_indice]="$line" # on stocke la ligne dans le tableau
    var_indice=$((var_indice + 1)) # indice + 1 pour passer à la ligne suivante (du tableau)
done < <(dos2unix < "$fichier")  # on utilise dos2unix pour convertir le fichier en format UNIX (pour éviter les problèmes de format (CLRF et LF))

if [[ ${#tableau_indi[@]} -eq 0 ]]; then
    echo "Erreur : Le fichier semble ne pas contenir de lignes valides."
    exit 1 # Gestion d'erreur
fi

echo "Liste des utilisateurs : ${tableau_indi[@]}"

longueur_tab=${#tableau_indi[@]} # On récupère la taille
#longueur_tab=$((longueur_tab / 4))
ecart_tabl=0 # écart tableau car chaque utilisateur a 4 informations (nom, groupe, shell, répertoire) donc on décale de 4 à chaque opération effectuée
for ((i=0; i<longueur_tab; i++)); do
    PASSWORD=$(openssl rand -base64 12)
    echo "Votre mot de passe est : $PASSWORD"

    user=${tableau_indi[0 + ecart_tabl]} # on récupère les informations de chaque utilisateur
    group=${tableau_indi[1 + ecart_tabl]}
    shell=${tableau_indi[2 + ecart_tabl]}
    rep=${tableau_indi[3 + ecart_tabl]}

    if ! getent group "$group" >/dev/null; then # si le groupe n'existe pas
        groupadd "$group" # on le crée
    fi

    if getent passwd "$user" >/dev/null; then # si l'utilisateur existe
        usermod -g "$group" -s "$shell" -d "$rep" "$user" # on modifie les informations
    else
        useradd -m -g "$group" -s "$shell" -d "$rep" "$user" # sinon on le crée
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

groupadd CEO
groupmod -c "CEO" CEO
groupadd Marketing
groupmod -c "Team responsible for all marketing activities" Marketing
groupadd ProductOwner
groupmod -c "Team responsible for managing devs" ProductOwner
groupadd Devs
groupmod -c "Team responsible for making products" Devs
groupadd RH
groupmod -c "Team responsible for hire new employee" RH

usermod -a -G CEO antoine
usermod -a -G Devs matheo
usermod -a -G ProductOwner jessica

# Si un groupe est modifie / un utilisateur est retiré, supprime les groupes vides


# Récupère tous les groupes
for group in $(getent group | cut -d: -f1); do # 'cut -d: -f1' ==> nom du groupe
  # Si le groupe est vide, alors...
  if [[ $(getent group "$group" | cut -d: -f4) == "" ]]; then # 'cut -d: -f4' ==> utilisateurs du groupe
    # Supprime le groupe
    groupdel "$group"
    echo "Group '$group' is empty and has been deleted!"
  else
    # Group is not empty, skip it
    echo "Group '$group' is not empty, skipping..."
  fi
done

echo "Group cleanup complete."


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