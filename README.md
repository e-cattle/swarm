### Conteúdo
- [Sobre](#sobre)
- [Execução do projeto via script](#executando-o-projeto-via-script)
- [Execução do projeto manualmente](#executando-o-projeto-manualmente)

## Sobre
O ambiente *cloud* da plataforma e-cattle é composto por diversos serviços organizados em *containers* dentro de uma rede *swarm*.
Este repositório é responsável por inicializar o ambiente *cloud* da plataforma. 

## Executando o projeto via script
Baixe o script *[cloud-script.sh](https://github.com/e-cattle/swarm/cloud-script.sh)* e execute os seguintes comandos
```
sudo chmod a+x cloud-script.sh
./cloud-script.sh
```

## Executando o projeto manualmente

### Iniciando rede *swarm* na interface eth0

```
docker swarm init --advertise-addr eth0
```
>##### Observação: O nó que executar o início da rede *swarm* será o *manager*

### Criando a rede para que todos os serviços façam parte e consigam se comunicar
```
docker network create manager_network --driver overlay --attachable 
```

### Adicione os nós *workers* na rede *swarm* conforme instruções geradas pelo comando anterior   
```
docker swarm join --token tokenGeradoPeloCOmandoAnterior ipEPortaGeradosPeloComandoAnterior
```

### Instalando portainer para gerenciamento do ambiente *swarm*
```
curl -L https://downloads.portainer.io/ce2-14/portainer-agent-stack.yml -o portainer-agent-stack.yml
docker stack deploy -c portainer-agent-stack.yml portainer
```
>##### Observação: Abrir porta 9000 no navegador e configurar usuário e senha para o portainer

### Fazer *download* do arquivo de configuração do ambiente *swarm*
```
wget https://github.com/e-cattle/swarm/swarm.yml
```

### Configurando variáveis de ambiente que serão utilizadas na rede *swarm* pelos *containers*
```
env NODE_ENV="" NODE_PORT="" MONGO_PORT=""  JWT_SECRET=""  
SMTP_HOST="" SMTP_PORT="" SMTP_SECURE="" SMTP_FROM="" DOCKER_EMAIL=""
VUE_APP_CLOUD="nomeStackSwarm_nomeServiçoCloudAPI"
```

### Executando *stack* do *swarm*
```
docker stack deploy -c swarm.yml nomeStackSwarm
```

### Explicação das variáveis de ambiente utilizadas anteriormente

- **NODE_ENV**: Especifica se o ambiente é *development*, *production* ou *test*;
- **NODE_PORT**: Porta que o Node do *container guest* será exposta no *host*;
- **MONGO_PORT**: Porta que o MongoDB do *container guest* será exposta no *host*;
- **JWT_SECRET**: Token utilizado pelo JWT no *payload*;
- **SMTP_HOST**: Nome do serviço de e-mail dentro da *stack*;
- **SMTP_PORT**: Porta do serviço de e-mail dentro da *stack*;
- **SMTP_SECURE**: Indica se o serviço SMTP utilizará SSL;
- **SMTP_FROM**: Texto padrão do campo Assunto do e-mail;
- **DOCKER_EMAIL**: Porta que o SMTP vai rodar no *host*;
- **VUE_APP_CLOUD**: Nome do serviço da API do ambiente *cloud*;

