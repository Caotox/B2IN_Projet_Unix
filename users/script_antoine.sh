#!/bin/bash
# exo 1
fichier="Names.txt"
var_indice=0
declare -a tableau_indi
while read line; do
    var_ligne=$line
    tableau_indi[$var_indice]="$line"
    var_indice=$(($var_indice + 1))
done < "$fichier"
echo "${tableau_indi[@]}"
ecart_tabl=0
longueur_tab=${#tableau_indi[@]}
longueur_tab=$(($longueur_tab/4))
for i in {0..$longueur_tab}; do  
    PASSWORD=$(openssl rand -base64 12)
    echo "Votre mot de passe est : $PASSWORD"
    user=${tableau_indi[0+$ecart_tabl]}
    group=${tableau_indi[1+$ecart_tabl]}
    shell=${tableau_indi[2+$ecart_tabl]}
    rep=${tableau_indi[3+$ecart_tabl]}
    if [ "$(getent passwd $user)" ]; then  
        if [ "$(getent group $group)" ]; then  
            groupadd $group
            useradd "$user" --groups "$group" --shell "$shell" --home "$rep" 
        else
            useradd "$user" --groups "$group" --shell "$shell" --home "$rep" 
        fi
    else
        if [ "$(getent group $group)" ]; then  
            groupadd $group
            usermod "$user" --groups "$group" --shell "$shell" --home "$rep" 
        else
            usermod "$user" --groups "$group" --shell "$shell" --home "$rep" 
        fi
    fi
    chage -M 30 $user
    ecart_tabl=$(($ecart_tabl + 4)) 
done
