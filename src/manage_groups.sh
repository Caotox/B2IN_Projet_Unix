#!/bin/bash

source src/better_reading.sh # intègre le script 'better_reading.sh' (= récupère toutes ses fonctions et variables)


groups=("CEO" "Marketing" "ProductOwner" "Devs" "RH")

# Pour ajouter un utilisateur à un groupe sans supprimer ses autres appartenances, utilisez l'option -a avec usermod
usermod -a -G CEO antoine
usermod -a -G Devs matheo
usermod -a -G RH jessica


# Script pour supprimer les groupes vides

# Récupère tous les groupes
for group_name in ${groups[@]}; do # récupère les noms de groupe de la PME
  # Si le groupe est vide, alors...
  if [[ $(getent group "$group_name" | cut -d: -f4) == "" ]]; then # 'cut -d: -f4' ==> récupère les utilisateurs du groupe
    # Supprime le groupe

    groupdel "$group_name"
    log_system "le groupe ${YELLOW}$group_name${RESET} est vide et a donc été ${RED}supprimé${RESET} !"
  fi
done