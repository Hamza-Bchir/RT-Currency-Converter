#!/bin/bash


#Déclaration par défaut
API_KEY='b2797e7193dcda148c061f5118343a89'
base_url='http://data.fixer.io/api/'
endpoint='latest'

#Fonction qui permet de calculer le taux d\'une paire de devises dont la base est l\'euro
function get_exchange_rate() {
	local base_currency=$1
	local target_currency=$2
	local api_url="$base_url$endpoint?access_key=$API_KEY&base=&base_currency"
	local exchange_rate=$( curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
	echo $exchange_rate
}

#Fonction qui permet d\'afficher la paire de devises choisies ainsi que le taux
function display_rate() {
	local currency_depart=$1
	local currency_darriv=$2
	local rate=$3
	echo "Le taux de change de $currency_depart vers $currency_darriv est de $rate"
	date
}


#Fonction qui permet de calculer le taux d\'une paire de devises dont la base n\'est pas l\'Euro
function base_changer(){
	local base_currency=$1
	local target_currency=$2
	local api_url="$base_url$endpoint?access_key=$API_KEY&base=EUR"
	local exchange_rate_EUR_newbase=$(curl -s "$api_url" | jq -r ".rates[\"$base_currency\"]")
	local exchange_rate_EUR_target_currency=$(curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
	local new_exchange_rate=$(bc <<< "scale=6; $exchange_rate_EUR_target_currency / $exchange_rate_EUR_newbase")
	echo $new_exchange_rate
}


# Traitement des options de ligne de commande
while getopts ":b:t:" opt; do
    case $opt in
        b)  # Spécifier la devise de départ
            currency_depart="$OPTARG"
            ;;
        t)  # Spécifier la devise d'arrivée
            currency_darriv="$OPTARG"
            ;;
        \?)
            echo "Option invalide: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

#Vérification des arguments de ligne de commande

if [ -z "$currency_depart" ] || [ -z "$currency_darriv" ]; then
	echo "Usage: $0 -b base_currency -t target_currency"
	exit 1
fi


#Structure conditionnel permet de choisis les fonctions selon le choix de la base
if [ "$currency_depart" != "EUR" ]; then
	rate="$(base_changer "$currency_depart" "$currency_darriv")"
	display_rate "$currency_depart" "$currency_darriv" "$rate"
else
	rate="$(get_exchange_rate "$currency_depart" "$currency_darriv")"
	display_rate "$currency_depart" "$currency_darriv" "$rate"
fi
