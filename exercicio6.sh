#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

# 1) X = Endereco escolhido; Y = IP do endereco; Z = Tamanho do pacote enviado.
# 2) A = Tamanho do pacote recebido; B = Dominio do destinatario; C = IP do destinatário.
# 3) Pois ha diversos sevidores do google e a conecxão se dá com o servidor mais proximo.

tamanho1=56
tamanho2=64

testPing()
{
	dominio=$1
	tamanho=$2
	ping -c 10 -s $tamanho $dominio | grep "time=" | cut -d '=' -f 4 | cut -d ' ' -f 1 | sort 

}

main()
{
	dominioAtual=$1
	tamanhoAtual=$2

	echo "Pacote de $tamanhoAtual bytes"

	soma=0.0
	somaMaiores=0.0
	mediana=0
	i=1
	
	tempos=$(testPing $dominioAtual $tamanhoAtual)
	numeroTempos=$(echo $tempos | tr ' ' '\n' | wc -l)
	meio=$(($numeroTempos / 2))
	tresMaiores=$(($numeroTempos - 3))
	for ms in $tempos; do
		soma=$(echo "$soma + $ms" | bc -l)
		if [ $i -eq $meio ]; then
			mediana=$ms
		fi
		if [ $i -gt $tresMaiores ]; then
			somaMaiores=$(echo "$somaMaiores + $ms" | bc -l)
		fi
		i=$((i + 1))
	done

	media=$(echo "$soma / $numeroTempos" | bc -l)

	numeroMaiores=3
	if [ $tresMaiores -lt 0 ]; then
		numeroMaiores=$(($tresmaiores + 3))
	fi

	mediaMaiores=$(echo "$somaMaiores / $numeroMaiores" | bc -l)
	
	echo "Mediana: $mediana"
	echo "Media dos 3 maiores tempos: $mediaMaiores"
	echo "Media geral dos tempos: $media"
}

main $1 $tamanho1
sleep 10
echo
main $1 $tamanho2
