# Ansible via Docker

Este projeto permite utilizar o **Ansible** sem instalá-lo diretamente no sistema operacional, utilizando um container Docker com todas as dependências necessárias.

## Pré-requisitos

- Docker instalado no sistema

## Como instalar o Docker

1. Acesse o site oficial: https://www.docker.com/get-started/
2. Baixe a versão mais recente compatível com seu sistema operacional
3. Conclua a instalação seguindo o assistente

## Clonar o repositório do GitHub

Via SSH:

```bash
git clone git@github.com:robsonvitor/docker-ansible.git 
```

Ou via HTTPS:

```
git clone https://github.com/robsonvitor/docker-ansible.git
```

Entre no diretório do projeto:

```
cd docker-ansible
```

## Compilar a imagem com as dependências

``` docker build -t ansible-img . ```

## Criar aliases para facilitar o uso

Alias para ansible:

```
alias ansible="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -w /apps ansible-img ansible"
```

Alias para ansible-playbook:

```
alias ansible-playbook="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -w /apps ansible-img ansible-playbook"
```

Dica: adicione os aliases ao arquivo ~/.bashrc ou ~/.zshrc para torná-los permanentes.

## Exemplos usando apenas ansible

Exemplo 1: testar conectividade com os hosts

``` ansible all -i hosts.ini -m ping ```

Arquivo hosts.ini:

```
[servidores]
192.168.1.10
192.168.1.11
```

Exemplo 2: verificar uso de disco nos servidores

```
ansible servidores -i hosts.ini -m shell -a "df -h"
```

## Estrutura de diretórios do projeto
``` 
ansible/
├── hosts.ini
├── playbook.yml
└── tasks/
    ├── install_packages.yml
    ├── users.yml
    └── services.yml
```

## Exemplo usando ansible-playbook


Arquivo playbook.yml:
``` 
- name: Configuração inicial dos servidores
  hosts: servidores
  become: true
  tasks:
    - import_tasks: tasks/install_packages.yml
    - import_tasks: tasks/users.yml
    - import_tasks: tasks/services.yml
```

Arquivo tasks/install_packages.yml:

``` 
- name: Instalar pacotes essenciais
  apt:
    name:
      - vim
      - curl
      - htop
    state: present
    update_cache: yes
```

Arquivo tasks/users.yml:
```
- name: Criar usuário deploy
  user:
    name: deploy
    shell: /bin/bash
    groups: sudo
    append: yes
```

Arquivo tasks/services.yml:

```YAML
- name: Garantir que o SSH esteja ativo
  service:
    name: ssh
    state: started
    enabled: yes
```

## Executando o playbook

```bash
ansible-playbook -i hosts.ini playbook.yml
```

Observações finais:

1. O diretório atual do projeto é montado dentro do container em /apps;
2. Essa abordagem garante isolamento, portabilidade e facilidade de manutenção.
