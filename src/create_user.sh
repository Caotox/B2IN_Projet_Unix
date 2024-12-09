#!/bin/bash


if [[ ! -f $1 || ! -s $1 ]]; then
    echo "Erreur : Le fichier '$1' est introuvable ou vide."
    exit 1
fi