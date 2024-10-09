#!/bin/bash

# exo 1
fichier="Names.txt";
var_indice=0
declare -a tableau_indi
while read line; do
var_ligne=$line
tableau_indi[$var_indice]="$line"
var_indice=$(($var_indice + 1))
done < "$fichier"
echo "${tableau_indi[@]}"

for i in "${!tableau_indi[@]}"; do
if [getent passwd $group]; then
groupadd $group
if [getent passwd $user]; then
useradd "$user" --groups "$group" --shell "$shell" --home "$home" -p "$(openssl passwd -1 passwd)" #-p $(mkpasswd passwd)
else
usermod -g $group --shell "$shell" --home "$home"
fi
else