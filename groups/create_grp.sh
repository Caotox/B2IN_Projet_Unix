#!/bin/bash
# Ce script créer les groupes et assigne les utilisateurs. Il ne doit être lancé qu'une seule fois !

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

usermod -a -G CEO antoine
usermod -a -G Devs matheo
usermod -a -G ProductOwner jessica