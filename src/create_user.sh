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
longueur_tab=$((longueur_tab / 4))
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