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

