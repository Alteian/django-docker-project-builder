#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 [directory] [command]"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Creating directory: $directory"
    mkdir -p "$directory"
fi

cp make_django.sh make_docker_compose.sh make_dockerfile.sh "$directory"

cd "$directory"

case "$2" in
    "build_project")
        echo "Building project"
        source ./make_django.sh
        ;;

esac

rm "$directory/make_django.sh" "$directory/make_docker_compose.sh" "$directory/make_dockerfile.sh"
