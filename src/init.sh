#!/bin/bash

# Création des groupes
groupadd CEO
groupmod -c "CEO" CEO
groupadd Marketing
groupmod -c "Team responsible for all marketing activities" Marketing
groupadd ProductOwner
groupmod -c "Team responsible for managing devs" ProductOwner
groupadd Devs
groupmod -c "Team responsible for making products" Devs
groupadd RH
groupmod -c "Team responsible for hire new employee" RH


# installation des packages utiles
sudo apt update -y
sudo apt install -y mailutils