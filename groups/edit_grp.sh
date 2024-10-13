#!/bin/bash
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