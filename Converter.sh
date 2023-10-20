#!/bin/bash


#Déclaration par défaut
API_KEY='b2797e7193dcda148c061f5118343a89'
base_url='http://data.fixer.io/api/'
endpoint='latest'


function get_exchange_rate() {
	local base_currency=$1
	local target_currency=$2
	local api_url="$base_url$endpoint?access_key=$API_KEY&base=&base_currency"
	local exchange_rate=$( curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
	echo $exchange_rate
}

function display_rate() {
	local currency_depart=$1
	local currency_darriv=$2
	local rate=$3
	echo "Le taux de change de $currency_depart vers $currency_darriv est de $rate"
}



function base_changer(){
	local base_currency=$1
	local target_currency=$2
	local api_url="$base_url$endpoint?access_key=$API_KEY&base=EUR"
	local exchange_rate_EUR_newbase=$(curl -s "$api_url" | jq -r ".rates[\"$base_currency\"]")
	local exchange_rate_EUR_target_currency=$(curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
	local new_exchange_rate=$(bc <<< "scale=6; $exchange_rate_EUR_target_currency / $exchange_rate_EUR_newbase")
	echo $new_exchange_rate
}


echo "Veuillez choisir la devise de départ"
read currency_depart
echo "Veuillez choisir la devise d'arrivée"
read currency_darriv
if [ "$currency_depart" != "EUR" ]; then
	rate="$(base_changer "$currency_depart" "$currency_darriv")"
	display_rate "$currency_depart" "$currency_darriv" "$rate"
else
	rate="$(get_exchange_rate "$currency_depart" "$currency_darriv")"
	display_rate "$currency_depart" "$currency_darriv" "$rate"
fi
