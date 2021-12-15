#!/bin/bash
IFS=', '
FILE=$HOME/massa/massa-node/config/config.toml
adresse="Votre adresse de staking ici"
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
nc -z -v $(hostname -I | awk -F " " {'print $1'}) 31244-31245
echo "Done!"
echo "_________________________"
echo ""
echo "Vérification du nombre de roll..."
cd ~/massa/massa-client
tout=$($HOME/massa/target/release/massa-client wallet_info)
nActiveRolls=$(echo "$tout" | grep "Active rolls" | awk -F " " {'print $3'})
FinalRolls=$(echo "$tout" | grep "Final rolls" | awk -F " " {'print $3'})
CandidateRolls=$(echo "$tout" | grep "Candidate rolls" | awk -F " " {'print $3'})
FinalBalance=$(echo "$tout" | grep "Final balance" | awk -F " " {'print $3'})
echo "Nombre de roll actif : $nActiveRolls"
echo "Final rolls : $FinalRolls"
echo "Candidate rolls : $CandidateRolls"
echo "Final balance : $FinalBalance"
if [[ "$CandidateRolls" == 1 ]]; then
    echo ""
    echo "L'achat de votre roll est en cours. Patientez environ 1h45."
elif [[ "$nActiveRolls" > 0 ]]; then
    echo ""
    echo "Vous avez au moins un roll d'actif."
else
    echo "Vous n'avez aucun roll d'actif! Il faut en acheter."
fi
echo "_________________________"
echo ""
echo "Vérification de la version de votre node..."
version=$($HOME/massa/target/release/massa-client get_status)
echo "$version" | grep "Version"
echo "_________________________"
echo ""
echo "Hardware requis minimum actuel : 4 core / 8GB RAM"
echo "Vos specs actuels : "
lscpu | grep "CPU(s)" | head -1
echo "Utilisation de la RAM : "
free -h
echo ""
echo "Pourcentage d'utilisation du CPU : "
ps -p $(pgrep massa-node) -o %cpu,%mem
echo "_________________________"
echo ""
echo ""
printf "Que voulez-vous faire ?\n\n1) Relancer le Massa Node\n2) Acheter un roll\n3) Consulter le wallet\n\n"

while true; do
    read -p "Faites votre choix : [1] [2] [3] [Q]uitter: " -a array
    for choice in "${array[@]}"; do
        case "$choice" in
            [1]* )
		   cd $HOME/massa/massa-node
		   pkill massa-node
		   nohup cargo run --release &
		   echo "Lancement du Massa-node en cours..."
		   sleep 4
		   ;;
            [2]* )
		   cd $HOME/massa/massa-client
		   lancement=$($HOME/massa/target/release/massa-client buy_rolls $adresse 1 0)
		   echo "Achat de roll : $lancement"
		   ;;
            [3]* )
		   #cd $HOME/massa/massa-client
		   #wallet=$($HOME/massa/target/release/massa-client wallet_info)
		   nActiveRolls=$(echo "$tout" | grep "Active rolls" | awk -F " " {'print $3'})
		   FinalRolls=$(echo "$tout" | grep "Final rolls" | awk -F " " {'print $3'})
		   CandidateRolls=$(echo "$tout" | grep "Candidate rolls" | awk -F " " {'print $3'})
		   FinalBalance=$(echo "$tout" | grep "Final balance" | awk -F " " {'print $3'})
		   echo ""
		   echo "Nombre de roll actif : $nActiveRolls"
		   echo "Final rolls : $FinalRolls"
		   echo "Candidate rolls : $CandidateRolls"
		   echo "Final balance : $FinalBalance"
		   echo ""
		   ;;
            [Qq]* ) echo "Vous avez quitter le programme."; exit;;
            * ) echo "C'est une blague :)) ???";;
        esac
    done
done
