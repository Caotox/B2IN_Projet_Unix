#!/bin/bash

# Définir les variables
DATE=$(date '+%Y-%m-%d')
RAPPORT="$1"
DUREE_INACTIVITE=30 # Durée en jours pour détecter les utilisateurs inactifs

# Créer un en-tête pour le rapport
echo "Rapport Système - Généré le $DATE" > $RAPPORT
echo "-----------------------------------" >> $RAPPORT
echo "" >> $RAPPORT
