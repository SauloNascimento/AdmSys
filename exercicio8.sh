#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

# metodo para obter as informações de um dominio recebido
contaIPs()
{

	link=$1 # Dominio passado ao metodo
	temp=$(mktemp)
	# Valores default para o numero de diferentes ips e para existencia de um dominio m.
	ips="ERRO"
	mobile=""

	getent hosts $link > $temp # Buscando ips para o dominio

	if [ $? -eq 0 ]; then # Se há ips:
		ips=$(wc -l $temp | cut -d " " -f 1) # Obtendo quantidade de ips encontrados
		getent hosts "m.$link" > $temp # Buscando ips para uma vercao mobile
		if [ $? -eq 0 ]; then # Se existir:
			# Obtendo quantidade de ips encontrados para o m.
			countMobile=$(wc -l $temp | cut -d " " -f 1)
			mobile=" / MOBILE: $countMobile"
		fi
	fi
	rm $temp
	echo "$link: $ips$mobile"
	

}

if [ $1 = "-f" ]; then # Se o usuario passou um arquivo:
	for url in $(cat $2); do # Para cada url no arquivo recebido:
		contaIPs $url
	done
else # Se nao foi um arquiv, foi um url, entao:
	contaIPs $1
fi
