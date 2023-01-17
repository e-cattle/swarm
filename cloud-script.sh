#!/bin/bash

# Tornando script case insensitive 
shopt -s nocasematch

# Título e opções do menu principal
PS3="Escolha qual tipo de nó o PC terá no ambiente cloud do e-cattle: "
options=("Manager" "Worker" "Sair")

# Estilizando script {verde: Informação geral, amarelo: Informação que requer atenção maior}
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

# Capturando nome do usuário linux e armazenando na variável user
user="$(id -u -n)"

# Capturando as interfaces de rede do computador e armazenando na variável interfaces
interfaces="$(ls /sys/class/net)"

# Instalação de softwares utilizados no decorrer do script
default_install()
{
    echo "${green}Atualizando repositório...${reset}"
    sleep "2s"
    sudo apt-get update
    sleep "2s"
    echo "${green}Instalando curl...${reset}"
    sleep "2s"
    sudo apt-get install curl software-properties-common apt-transport-https -y
    sleep "2s"
    echo "${green}Instalando Docker...${reset}"
    sleep "2s"
    sudo apt-get install docker.io -y
    echo "${green}Configurando Docker...${reset}"
    sleep "2s"
    sudo usermod -aG docker ${user}
    sudo chmod 666 /var/run/docker.sock
    sleep "2s"
}

# Cria a rede swarm do zero
create_manager()
{
    PS3="Escolha qual interface será utilizada para a rede swarm: "
    default_install
    echo "${green}Criando rede swarm...${reset}"
    sleep "1s"
    echo "${green}Escolhendo interface${reset}"
    sleep "2s"
    select interface in $interfaces; do
        echo "${green}Criando rede swarm em $interface${reset}";
        docker swarm init --advertise-addr $interface
        sleep "2s"
        echo "${yellow}Atenção: copie o código indicado acima e cole nos nós Workers${reset}"
        sleep "2s"
        echo "${green}Criando network na rede swarm...${reset}"
        sleep "2s"
        docker network create swarm_network --driver overlay --attachable
        sleep "2s"   
        echo "${green}Baixando e instalando portainer para gerenciamento da rede swarm...${reset}"
        sleep "2s"
        curl -L https://downloads.portainer.io/ce2-16/portainer-agent-stack.yml -o portainer-agent-stack.yml
        docker stack deploy -c portainer-agent-stack.yml portainer
        echo "${green}Abrir portainer em http://localhost:9000${reset}"
        sleep "2s"
        break
    done
    sleep "2s"
    PS3="Escolha qual tipo de nó o PC terá no ambiente cloud do e-cattle: "
}

# Cria um nó worker
create_worker()
{
  echo "CRIAR WORKER"
  default_install
  sleep "2s"
  echo "${green}Execute o seguinte comando no nó Manager da rede swarm${reset}"
  echo "${yellow}docker swarm join-token worker${reset}"
  echo "${green}Cole o código resultante aqui${reset}"
}

# Menu principal do script
select choice in "${options[@]}"; do
    case $choice in
        "Manager")
            echo "Você escolheu $choice"
            create_manager
            break;;
        "Worker")
            echo "Você escolheu $choice"
            create_worker
            break;;
    "Sair")
        exit
        ;;
        *) echo "Opção Inválida $REPLY";;
    esac
done
