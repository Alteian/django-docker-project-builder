#!/bin/bash

read -p "Enter Python image version (default: python:3.11.1-buster): " python_image
python_image=${python_image:-python:3.11.1-buster}

cat << EOF > "$project/Dockerfile"
FROM $python_image

RUN mkdir /code

RUN python -m pip install --upgrade pip

RUN pip install gunicorn

COPY requirements.txt ./

RUN python3 -m pip install -r requirements.txt

COPY ./ /code/

WORKDIR /code
EOF