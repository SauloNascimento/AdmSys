#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

url=$1

temp=$(mktemp)

mod()
{
	if [ $1 -ge 0 ]; then
		echo $1
	else
		echo $((0 - $1))
	fi
}

# Armazenando num arquivo temporario o cabecalho da requisicao e o tempo que leva para receber respostas
(time (curl -I $url > $temp)) 2>> $temp

# Hora atual da máquina
tMaq=$(date +%H:%M:%S)

# Hora do servidor
tSrv=$(grep "Date:" $temp | cut -d ' ' -f 6)

# Calculando o tempo que levou a requisicao
real=$(grep "real" $temp | awk -F " " '{print $2}')
real_m=$(echo $real | cut -d 'm' -f 1)
real_s=$(echo $real | cut -d 'm' -f 2 | cut -d 's' -f 1)
rtt=$(echo "$real_m *60000 + $real_s * 1000" | bc -l | cut -d '.' -f 1)

# Hora do servidor em segundos
tSrvS=$(date -d $tSrv +%s)

# Hora atual da máquina em segundos
tMaqS=$(date -d $tMaq +%s)

# Calculo da diferenca entre os tempos
diferenca=$(($tMaqS - $tSrvS))

echo $rtt
echo $tSrv
echo $tMaq
echo $diferenca

# Diferenca no formato HH:MM:SS
date -d @$(($(mod $diferenca) + 10800)) +%H:%M:%S

rm $temp
