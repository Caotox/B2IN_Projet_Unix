#!/bin/bash

## Script pour reset les modifications du script principal (utilisé pour les tests uniquement!)

# RESET
echo "Réinitialisation du système en cours..."


# Supprimer les utilisateurs créés
echo "Suppression des utilisateurs ajoutés..."
for user in antoine matheo jessica; do
    if getent passwd "$user" >/dev/null; then
        echo "Suppression de l'utilisateur : $user"
        sudo userdel -r "$user"
    else
        echo "L'utilisateur $user n'existe pas, passage au suivant."
    fi
done


# Supprimer les groupes créés
echo "Suppression des groupes ajoutés..."
for group in CEO Marketing ProductOwner Devs RH; do
    if getent group "$group" >/dev/null; then
        echo "Suppression du groupe : $group"
        sudo groupdel "$group"
    else
        echo "Le groupe $group n'existe pas, passage au suivant."
    fi
done


# Nettoyer les fichiers de sauvegarde
backup_dir="/backup"
if [[ -d "$backup_dir" ]]; then
    echo "Suppression des fichiers de sauvegarde dans $backup_dir..."
    sudo rm -rf "$backup_dir"/*
else
    echo "Le répertoire $backup_dir n'existe pas, aucune sauvegarde à supprimer."
fi


# Réinitialisation des ACL
echo "Réinitialisation des ACL sur les répertoires RH et CEO..."
repertoire_rh="/../../rh_directory"
repertoire_direction="/../t../direction_directory"

if [[ -d "$repertoire_rh" ]]; then
    setfacl -b "$repertoire_rh" # Suppression des ACL
    echo "ACL réinitialisées pour $repertoire_rh."
else
    echo "Le répertoire $repertoire_rh n'existe pas."
fi

if [[ -d "$repertoire_direction" ]]; then
    setfacl -b "$repertoire_direction" # Suppression des ACL
    echo "ACL réinitialisées pour $repertoire_direction."
else
    echo "Le répertoire $repertoire_direction n'existe pas."
fi


# Suppression des groupes vides restants
echo "Suppression des groupes vides..."
for group in $(getent group | cut -d: -f1); do
    if [[ $(getent group "$group" | cut -d: -f4) == "" ]]; then
        sudo groupdel "$group"
        echo "Groupe vide supprimé : $group."
    fi
done

echo "Réinitialisation terminée."
