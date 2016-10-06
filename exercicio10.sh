#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

# Funcao que verifica se o checksum é igual ao passado utilizando o algoritimo indicado
# Caso o algoritico passado não exista, ocorre um exit 3
verifica()
{
	comando=$1
	documento=$2
	esperado=$3
	if test -f "$documento"; then # Se o documento passado e um arquivo existente
		if [ $comando = "MD5" ]; then # Se o comado e md5sum:
			resultado=$(md5sum "$documento" | cut -d ' ' -f 1)
			if [ "$resultado" = "$esperado" ]; then
				echo "OK"
			else
				echo "ERRO; Esperado: $esperado; Atual: $resultado"
			fi

		elif [ $comando = "CRC" ]; then # Se o comado e cksum:
			resultado=$(cksum "$documento" | cut -d ' ' -f 1)
			if [ "$resultado" = "$esperado" ]; then
				echo "OK"
			else
				echo "ERRO; Esperado: $esperado; Atual: $resultado"
			fi

		elif [ $comando = "SHA1" ]; then # Se o comado e sha1sum:
			resultado=$(sha1sum "$documento" | cut -d ' ' -f 1)
			if [ "$resultado" = "$esperado" ]; then
				echo "OK"
			else
				echo "ERRO; Esperado: $esperado; Atual: $resultado"
			fi

		else # Se nao:
			echo "$comando nao e um algoritimo valido."
			exit 3
		fi
	else # Se o documento nao existe:
		echo "NOT_FOUND"
	fi
}

entrada=$1

if [ $# -ne 1 ]; then # Se nao receber nem um parametro:
	echo "Numero de parametros invalido."
	exit 2
elif test -f $entrada; then # Se o parametro for um arquivo existente:
	cat $entrada | while read line; do # Leitura de cada linha do arquivo, e para cada uma:
		# Armazenando o valor de checsum esperado, algoritimo a ser utilizado e nome do arquivo.
		valor=$(echo $line | cut -d ' ' -f 1)
		algoritimo=$(echo $line | cut -d ' ' -f 2)
		arquivo=$(echo $line | cut -d ' ' -f 3-)
		# Status da verificacao
		status=$(verifica $algoritimo "$arquivo" "$valor")
		saida=$? 
		if [ $saida -eq 0 ]; then # Se a verificacao ocorreu bem:
			echo "$status $arquivo"
		else # Se não:
			echo $status
			exit $saida
		fi

	done
else # Se não for:
	echo "Arquivo nao encontrado."
	exit 1
fi
