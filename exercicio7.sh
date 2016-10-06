#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

# Como funcionalidade adicional, optei por imprimir o numero de ocorencia de cada palavra na pagina, no lugar de "OK!"

sites=$1
temp=$(mktemp)

cat $sites | while read url; do # Para cada url listada no arquivo
	wget $url 2> $temp # Salvando as informações de leitura
	# Recuperacao do status retornado
	status=$(grep "aguardando resposta..." $temp | tail -n 1 | cut -d "." -f 4 | cut -d " " -f 2)

	# Impressao do url e status
	echo "$url $status"

	# Se a requisicao foi bem sucedida
	if [ $status -eq 200 ]; then
		# Recuperando arquivo onde a pagina foi salva pelo comando wget
		html=$(ls | grep "index.")

		if [ $# -gt 1 ]; then # Se houver um segundo parametro

			# Listagem de cada paravra no arquivo com seu numero de ocorrencia
			for palavra in $(cat $2); do
				echo $(grep -c $palavra $html) "ocorrencias de $palavra"
			done

		fi

		rm $html
	fi

done

rm $temp
