# projet_unix
**Groupe:** 1
- Mathou <3
- Jessou
- Antou

</br>

---
**Sujet choisi:** Projet 2
> Partie 1 => Antoine

> Partie 2 => jj

> Partie 3 => Matheo

> Partie 4 => jj

> Bonus => Tous

## Prérequis
Votre machine doit être sous Linux Debian 12 pour faire fonctionner correctement tous les scripts.</br>

Pour se connecter en SSH, elle doit être configuré en réseau bridge.</br>

Mais également contenir un utilisateur avec les permissions sudo.
```sh
su #se connecter au root
usermod -aG sudo <username>
```

## Quick Start

1. cloner le repo
```sh
apt install git # si ce n'est pas déjà fait
git clone https://github.com/Caotox/B2IN_Projet_Unix.git
```


```sh
sudo apt install zsh
sudo apt install fish
sudo apt install mailutils
```

2. se connecter à un utilisateur en ssh ([plus d'information ici](https://aymeric-cucherousset.fr/se-connecter-en-ssh-sur-debian-11/))
```sh
sudo apt install openssh-server

sudo systemctl enable ssh
sudo systemctl start ssh
```

regarder son ip
```sh
ip a
```

se connecter depuis une invite de commande externe
```sh
ssh <username>@<ip-address>
```
si la commande précédente génère un message d'erreur, jetez un coup d'oeil 👀 [ici](KEYGENERROR.MD)

3. lancer le programme
```sh
sudo bash manage_unix.sh
```

## Licence
Free Software