#!/bin/bash

# Установка необходимых пакетов
sudo apt update
sudo apt install -y git docker.io docker-compose

# Переходим в каталог /opt
cd /opt

# Клонируем репозиторий в /opt (замените на правильный URL вашего репозитория)
git clone https://github.com/flugegeheimen1337/netology2.git

# Переходим в каталог с репозиторием
cd netology2

# Создаем файл .env с необходимыми переменными
cat <<EOF > .env
MYSQL_ROOT_PASSWORD=YtReWq4321
MYSQL_DATABASE=virtd
MYSQL_USER=app
MYSQL_PASSWORD=QwErTy1234
MYSQL_HOST=db
MYSQL_PORT=3306
EOF

# Создаем файл docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3.9"

services:
  proxy:
    image: nginx:latest
    ports:
      - "8090:80"
    networks:
      backend:
        ipv4_address: 172.20.0.2

  web:
    image: cr.yandex/crp9mghfl62emh4c90cu/test:latest
    container_name: web
    restart: always
    env_file: .env
    networks:
      backend:
        ipv4_address: 172.20.0.5

  db:
    image: mysql:8
    container_name: db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: \${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: \${MYSQL_DATABASE}
      MYSQL_USER: \${MYSQL_USER}
      MYSQL_PASSWORD: \${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      backend:
        ipv4_address: 172.20.0.10

volumes:
  db_data:

networks:
  backend:
    external: true
    name: netology2_backend
EOF

# Запуск Docker Compose
sudo docker-compose up -d
