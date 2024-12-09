#!/bin/bash

# Ce script initialise tous les autres scripts : création des utilisateurs, création des groupes

source src/better_reading.sh # intègre le script 'better_reading.sh' (= récupère toutes ses fonctions et variables)
create_question() {
    read -p "$1" response
    if [[ "$response" == "o" ]]; then
        return 0  # true
    else
        return 1  # False
    fi
}


utilisateur=$(whoami)
log_info "Bienvenue administrateur ${BLUE}$utilisateur${RESET} sur le gestionnaire automatisé des utilisateurs et des groupes de l'entreprise '<undefined>'"

if [[ $EUID -ne 0 ]]; then
    log_error "Ce script bash doit être lancé avec les permissions sudo"
    exit 1
fi



# Init
log_info "Initialisation..."
# Some things to load...
sudo bash src/init.sh
log_success "Initialisation terminée !"
echo ""
echo ""

create_question "Continuer ? (o/n)"
if [[ $? -eq 1 ]]; then
    exit 1
fi


# Etape 1
log_info "Etape 1: Ajouter / modifier des utilisateurs"
sudo bash src/create_user.sh "Names.txt" || { log_error "Erreur inattendu lors de la création des utilisateurs. Vérifiez le chemin du fichier"; exit 1; }
log_success "Processus terminé avec succès."
echo ""
echo ""

create_question "Continuer ? (o/n)"
if [[ $? -eq 1 ]]; then
    exit 1
fi


# Etape 2
log_info "Etape 2: Gestion des utilisateurs inactifs"
sudo bash src/afk_user.sh 90 || { log_error "Erreur inattendu lors de la gestion des utilisateurs."; exit 1; }
log_success "Processus terminé avec succès."
echo ""
echo ""

create_question "Continuer ? (o/n)"
if [[ $? -eq 1 ]]; then
    exit 1
fi


# Etape 3
log_info "Etape 3: Gestion des groupes"
sudo bash src/manage_groups.sh || { log_error "Erreur inattendu lors de la gestion des groupes."; exit 1; }
log_success "Processus terminé avec succès."
echo ""
echo ""

create_question "Continuer ? (o/n)"
if [[ $? -eq 1 ]]; then
    exit 1
fi


# Etape 4
log_info "Etape 4: Gestion des ACL (Access Control List)"
sudo bash src/manage_acl.sh || { log_error "Erreur inattendu lors de la gestion des ACL."; exit 1; }
log_success "Processus terminé avec succès."
echo ""
echo ""

create_question "Continuer ? (o/n)"
if [[ $? -eq 1 ]]; then
    exit 1
fi


# Etape 5 (BONUS)
log_info "Etape 5: Rapport"
create_question "Voulez-vous générer un rapport ? (o/n)"
if [[ $? -eq 1 ]]; then
    sudo bash src/logs.sh || { log_error "Erreur inattendu lors de la création du rapport."; exit 1; }
    log_info "Rapport rédigé : ${YELLOW}'./logs.log'${RESET}"
else
    log_info "Aucun rapport ne sera rédigé."
fi
log_success "Processus terminé avec succès."
echo ""
echo ""


log_success "${CHECK} : Script éxecuté sans erreurs."