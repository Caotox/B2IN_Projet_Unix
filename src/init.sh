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
create_group_if_not_exists "CEO" "CEO"
create_group_if_not_exists "Marketing" "Team responsible for all marketing activities"
create_group_if_not_exists "ProductOwner" "Team responsible for managing devs"
create_group_if_not_exists "Devs" "Team responsible for making products"
create_group_if_not_exists "RH" "Team responsible for hiring new employees"


# installation des packages utiles
sudo apt update -y
sudo apt install -y mailutils