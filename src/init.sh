#!/bin/bash


create_group() {
    group_name=$1
    description=$2

    # Vérifier si le groupe existe
    if getent group "$group_name" > /dev/null 2>&1; then
        echo "Le groupe '$group_name' existe déjà."
        # Modifier la description si nécessaire
        sudo groupmod -c "$description" "$group_name"
        echo "Description du groupe '$group_name' modifiée."
    else
        # Créer le groupe si il n'existe pas
        echo "Création du groupe '$group_name'..."
        sudo groupadd "$group_name"
        sudo groupmod -c "$description" "$group_name"
        echo "Le groupe '$group_name' a été créé et sa description ajoutée."
    fi
}

# Création des groupes
create_group "CEO" "CEO"
create_group "Marketing" "Team responsible for all marketing activities"
create_group "ProductOwner" "Team responsible for managing devs"
create_group "Devs" "Team responsible for making products"
create_group "RH" "Team responsible for hiring new employees"


# installation des packages utiles
sudo apt update -y              # met à jour l'installateur de packets
sudo apt install -y dos2unix    # convertisseur format unix
sudo apt install -y mailutils   # envoie de mails