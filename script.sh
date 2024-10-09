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

