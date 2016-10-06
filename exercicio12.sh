#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

if [ $1 = "-z" ]; then # Se o parametro -z foi passado:
	origem=$2
	destino=$3
	if [ -d $origem ] && [ -d $destino ]; then # Se as pastas passadas existem
		origemNome=$(echo $origem | awk -F "/" '{print $NF}') # Obtendo o nome da pasta origem
		echo "Criando backup de $origem em $destino/$origemNome.zip"
		if [ -e "$destino/$origemNome.zip" ]; then # Se ja existe o arquivo compactado
			echo "Erro: Arquivo existente $destino/$origemNome.zip"
			exit 1
		else # Se nao existe:
			zip -r "$destino/$origemNome.zip" $origem
		fi
	else # Caso pelo menos um dos diretorios nao exista:
		echo "$origem e/ou $destino não é um diretorio."
		exit 2
	fi
else # Se apenas o nome das pastas foi passado:
	origem=$1
	destino=$2
	if [ -d $origem ] && [ -d $destino ]; then # Se as pastas passadas existem
		origemNome=$(echo $origem | awk -F "/" '{print $NF}') # Obtendo o nome da pasta origem
		numero=$(ls $destino | grep -v "$origemNome.zip" | grep -c $origemNome) # Contanto o numero de backups existentes
		if [ $numero -gt 0 ]; then # Se existir algum
			# Verificando a contagem dos backps
			numeroBackup=$(ls $destino | grep $origemNome | cut -s -d "." -f 2 | sort -g | tail -n 1)

			# Incrementacao da cntagem 
			if [ -n "$numeroBackup" ]; then
				numeroBackup=$(($numeroBackup + 1))
			else
				numeroBackup=1
			fi

			echo "Criando backup de $origem em $destino/$origemNome.$numeroBackup"

			cp -r $origem "$destino/$origemNome.$numeroBackup"

			# Remocao de baucks velhos
			if [ $numero -eq 4 ] && [ $numeroBackup -eq 4 ]; then # Se existem 4 e criou o numero 4
				rm -rf "$destino/$origemNome"
			elif [ $numero -eq 4 ] && [ $numeroBackup -gt 4 ]; then # Se existem 4 e criou uma numeracao acima de 4
				remover=$(($numeroBackup - 4))
				rm -rf "$destino/$origemNome.$remover"
			fi
		else # Se nao existe nenhum
			echo "Criando backup de $origem em $destino/$origemNome"
			cp -r $origem $destino
		fi
	else # Caso pelo menos um dos diretorios nao exista:
		echo "$origem e/ou $destino não é um diretorio."
		exit 2
	fi
fi
