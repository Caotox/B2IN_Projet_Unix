#!/bin/bash

groups=("CEO" "Marketing" "ProductOwner" "Devs" "RH")

# Pour ajouter un utilisateur à un groupe sans supprimer ses autres appartenances, utilisez l'option -a avec usermod
usermod -a -G CEO antoine
usermod -a -G Devs matheo
usermod -a -G ProductOwner jessica


# Script pour supprimer les groupes vides

# Récupère tous les groupes
for group_name in ${groups[@]}; do # récupère les noms de groupe de la PME
  # Si le groupe est vide, alors...
  if [[ $(getent group "$group_name" | cut -d: -f4) == "" ]]; then # 'cut -d: -f4' ==> récupère les utilisateurs du groupe
    # Supprime le groupe

    groupdel "$group_name"
    echo "Group '$group_name' is empty and has been deleted!"
  fi
done