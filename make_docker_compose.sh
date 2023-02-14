#!/bin/bash

read -p "Enter the Docker Compose version (default: 3.8): " version
version=${version:-3.8}

read -p "Enter the name of project: (default: ProjectAlteian): " project
project=${project:-ProjectAlteian}

read -p "Enter the Django image name: (default: alteian_unchained)" django_image
django_image=${django_image:-alteian_unchained}

read -p "Enter the command to start the Django server (default: 'python manage.py runserver 0.0.0.0:8000'): " django_command
django_command=${django_command:-"python manage.py runserver 0.0.0.0:8000"}

read -p "Enter the name of the Postgres image (default: postgres): " postgres_image
postgres_image=${postgres_image:-postgres}

read -p "Enter the name of the Postgres host (default: postgres): " postgres_host
postgres_host=${postgres_host:-postgres}

read -p "Enter the name of the Postgres port (default: 5432:5432): " postgres_port
postgres_port=${postgres_port:-5432:5432}

read -p "Enter the name of the Postgres database (default: postgres): " postgres_database
postgres_database=${postgres_database:-postgres}

read -p "Enter the name of the Postgres user (default: postgres): " postgres_user
postgres_user=${postgres_user:-postgres}

read -p "Enter the password for Postgres user (default: postgres): " postgres_password
postgres_password=${postgres_password:-postgres}

read -p "Enter the name of the Docker volume for Postgres data (default: postgresql_data): " postgres_volume
postgres_volume=${postgres_volume:-postgresql_data}

read -p "Enter the name of the Docker network (default: AlteianNetwork): " docker_network
docker_network=${docker_network:-AlteianNetwork}

cat << EOF > docker-compose.yml
version: "$version"

services:
  web:
    image: $django_image
    env_file:
      - .env
    build:
      context: .
      dockerfile: $project/Dockerfile
    command: "$django_command"
    ports:
      - 8000:8000
    volumes:
      - ./$project/:/code/$project/
      - ./manage.py:/code/manage.py
    networks:
      - $docker_network
    depends_on:
      - postgres

  postgres:
    restart: unless-stopped
    image: $postgres_image
    environment:
      POSTGRES_HOST: $postgres_host
      POSTGRES_DATABASE: $postgres_database
      POSTGRES_USER: $postgres_user
      POSTGRES_PASSWORD: $postgres_password
    env_file:
      - .env
    volumes:
      - $postgres_volume:/var/lib/postgresql
      - /tmp:/backups
    networks:
      - $docker_network
    ports:
      - $postgres_port

volumes:
  $postgres_volume:

networks:
  $docker_network:
    driver: bridge
    ipam:
      driver: default
EOF