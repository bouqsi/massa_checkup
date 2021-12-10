#!/bin/bash
FILE=$HOME/massa/massa-node/config/config.toml
if [ -f "$FILE" ]; then
    echo "Le fichier $FILE existe. Voici son contenu : "
    cat "$FILE"
    echo -e "\e[1mAvez-vous vérifier que l'adresse IP de votre node est bien indiqué ?\e[0m"
else 
    echo "Le fichier $FILE n'existe pas. Il faut le créer."
fi
echo "_________________________"
echo ""
echo "Vérification de l'ouveture des ports [succeeded c'est OK] - [failed = vos ports sont fermés]..."
nc -z -v YOUR_IP 31244-31245
echo "Done!"
echo "_________________________"
echo ""
echo "Vérification du nombre de roll..."
cd ~/massa/massa-client
tout=$(~/massa/target/release/massa-client wallet_info)
nActiveRolls=$(echo "$tout" | grep "Active rolls" | awk -F " " {'print $3'})
echo "Nombre de roll actif : $nActiveRolls"
if [[ "$nActiveRolls" > 0 ]]; then
    echo "Vous avez au moins un roll d'actif"
else
    echo "Vous n'avez aucun roll d'actif! Il faut en acheter."
fi
echo "_________________________"
echo ""
echo "Vérification de la version de votre node..."
version=$(~/massa/target/release/massa-client get_status)
echo "$version" | grep "Version"

