#!/bin/bash

#Déclaration par défaut
API_KEY='b2797e7193dcda148c061f5118343a89'
base_url='http://data.fixer.io/api/'
endpoint='latest'

function get_exchange_rates() {
        base_currency=$1
        target_currency=$2
        endpoint='latest'
        api_url="$base_url$endpoint?access_key=$API_KEY&base=$base_currency"

        #Utilisation du curl pour obtenir les données depuis l'API
        exchange_rate=$(curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
        echo $exchange_rate
}

function get_exchange_rates_2()
{
	base_currency=$1
	target_currency=$2
	endpoint='latest'
	api_url="$base_url$endpoint?access_key=$API_KEY&base=&base_currency"
	request_response=$(curl -s "$api_url")
	echo $request_response
}

function Base_Changer(){
	base_currency=$1
	target_currency=$2
	api_url="$base_url$endpoint?access_key=$API_KEY&base=EUR"
	exchange_rate_EUR_newbase=$(curl -s "$api_url" | jq -r ".rates[\"$base_currency\"]")
	exchange_rate_EUR_target_currency=$(curl -s "$api_url" | jq -r ".rates[\"$target_currency\"]")
	new_exchange_rate=$(bc <<< "scale=6; $exchange_rate_EUR_target_currency / $exchange_rate_EUR_newbase")
	echo $new_exchange_rate
}
echo "Veuillez choisir la devise de départ"
read currency_depart
echo "Veuillez choisir la devise d'arrivée"
read currency_darriv
if [ "$currency_depart" != "EUR" ]; then
	Base_Changer "$currency_depart" "$currency_darriv"
else
	echo "Reponse avec filtre ?(y/n)"
	read response_function
	if [ "$response_function" == "y" ]; then
		get_exchange_rates "$currency_depart" "$currency_darriv"
	else
		get_exchange_rates_2 "$currency_depart" "$currency_darriv"
	fi
fi
