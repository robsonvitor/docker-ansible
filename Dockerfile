FROM alpine/ansible:latest

# Instala dependências de compilação e ferramentas de rede
RUN apk update && \
    apk add --no-cache \
    git \
    openssh-client \
    sshpass \
    python3-dev \
    py3-pip \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    make \
    expat \
    libxml2 \
    python3-dev \
    build-base

# Cria diretório de trabalho
WORKDIR /ansible

# Copia arquivos de requisitos
COPY requirements.yml /tmp/requirements.yml
COPY requirements.txt /tmp/requirements.txt

# 1. Instala dependências Python via pip
RUN pip install --no-cache-dir --break-system-packages -r /tmp/requirements.txt

# 2. Instala as collections do Ansible Galaxy (sempre na última versão)
RUN ansible-galaxy collection install -r /tmp/requirements.yml

# Limpeza para diminuir a imagem
RUN rm /tmp/requirements.yml /tmp/requirements.txt && \
    apk del python3-dev gcc musl-dev libffi-dev openssl-dev make

CMD ["ansible-playbook", "--version"]
