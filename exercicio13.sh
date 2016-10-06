#!/bin/bash

# Saulo Samuel ferreira do Nascimento

# Funcao para o -e:
exist()
{
	if [ ! -f "$2/$1" ]; then # Se o arquivo nao existe:
		cp "$1" "$2" # Cria uma copia do arquivo no diretorio
	fi
}

# Funcao para o -s:
sub()
{
	temp=$(mktemp)
	ls -R "$2" | grep -v "$2" > $temp # Listando o diretorio e seus subdiretorios, ignorando o caminho deles.
	nomeArq=$(echo "$1" | awk -F "/" '{print $NF}')
	contador=$(grep -c "^$nomeArq$" $temp) # Contando a quantidade de vezes que o arquivo foi listado
	if [ $contador -eq 0 ]; then # Se nenhuma vez:
		cp "$1" "$2" # Cria uma copia do arquivo no diretorio
	fi
	rm $temp
}

# Funcao para o -d:
delete()
{
	if [ -f "$2/$1" ]; then # Se o arquivo existe no diretorio
		rm "$2/$1" # Removendo
	fi
}

# Funcao para o -c:
contains()
{
	quantidade=$(grep -c "$1" "$2") # Contando a ocorrencia da palavra no arquivo
	if [ $quantidade -eq 0 ]; then # Se nao ocorreu:
		echo "$1" >> "$2" # Escrevendo a palavra no arquivo
	fi
}

# Funcao para o -x:
copyAll()
{
	temp=$(mktemp)
	ls -R "$2" | grep "^$2" > $temp # Listando o diretorio e seus subdiretorios, guardando apenas os caminhos
	cat $temp | while read linha; do # Para cada caminho:
		pasta=$(echo "$linha" | cut -d ":" -f 1)
		cp "$1" "$pasta" # Cria uma copia do arquivo no diretorio repesentado pelo caminho
	done
	rm $temp
}

opcao=$1

case $opcao in # Caso a opcao seja:
	"-e")
		exist $2 $3
		;;

	"-s")
		sub $2 $3
		;;

	"-d")
		
		delete $2 $3
		;;

	"-c")
		contains $2 $3
		;;

	"-x")
		copyAll $2 $3
		;;
esac
