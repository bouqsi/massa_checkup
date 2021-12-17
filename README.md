Massa Node Check-Up

Ce script a pour but d'aider les utilisateurs de Massa Labs à avoir un premier diagnostic si le node ne fonctionne pas / rencontre une erreur.

Placez le à la racine de votre user.

wget https://raw.githubusercontent.com/bouqsi/massa_checkup/main/checkup_massa.sh && chmod +x checkup_massa.sh

Renseignez votre adresse de staking dans le fichier.

nano checkup_massa.sh
adresse="Votre adresse de staking ici"


Pour lancer le script : 

./checkup_massa.sh
