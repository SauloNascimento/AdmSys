#!/bin/bash

# Saulo Samuel Ferreira do Nascimento

host=$1

# Baixa os arquivos do host recebido
# -q para não inprimir no terminal
# -r para que o dowload seja recursivo (entre nas pastas que encontrar e baixe o que esta la dentro)
# -R ".html" para nao salvar os htmls das páginas
wget -q -r -R ".html" $host

