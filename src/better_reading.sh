#!/bin/bash

# Couleurs et styles
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m' # Réinitialiser le style

# Icônes Unicode
CHECK="\u2714"  # ✔
CROSS="\u2716"  # ✖
ARROW="\u2794"  # ➔


# Fonctions pour affichage
log_success() {
    echo -e "${GREEN}[SUCCÈS]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERREUR]${RESET} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_system() {
    echo -e "${BLUE}[SYSTÈME]${RESET} ACTION: $1"
}