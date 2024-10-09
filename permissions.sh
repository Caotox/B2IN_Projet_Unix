#!/bin/bash

repertoire_rh="/../../rh_directory" #faire des chemins pour les répertoires RH et Direction
repertoire_direction="/../t../direction_directory"

groupe_rh="RH" #voir avec matheo les groupes qu'il aura créés
groupe_direction="Direction"

setfacl -m g:$groupe_rh:r-- $repertoire_rh #lecture seule pour leur répertoire

setfacl -d -m g:$groupe_rh:r-- $repertoire_rh #lecture seule par défaut


setfacl -m g:$groupe_direction:rw- $repertoire_direction #lecture et écriture pour leur répertoire

setfacl -d -m g:$groupe_direction:rw- $repertoire_direction #lecture et écriture par défaut


echo "ACL sur le répertoire RH :"
getfacl $repertoire_direction

echo "ACL sur le répertoire Direction :"
getfacl $repertoire_direction

#à voir en fonction qui aura quelles perm sur quels répertoires mais je fais avec ce que je peux pour l'instant