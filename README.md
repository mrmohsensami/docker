# Docker
![docker](https://raw.githubusercontent.com/mrmohsensami/docker/main/img/docker.jpg "docker")

![docker](https://raw.githubusercontent.com/mrmohsensami/docker/main/img/docker2.jpg "docker")

![docker](https://raw.githubusercontent.com/mrmohsensami/docker/main/img/docker3.jpg "docker")

```shell
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
```shell
sudo systemctl status docker
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER
/etc/resolv.cont
/etc/netplan
sudo netplan apply
```
## image
```docker
docker images
docker pull hello-world
docker run hello-world
docker ps
docker ps -a
```
## basics
```docker
docker run --name mohsen hello-world
docker rm mohsen
docker container prune
docker rmi hello-world
docker run --rm hello-world
docker run busybox ls
docker run -it busybox
```
## image
```docker
docker run -d redis
docker ps
docker run -dit busybox
docker ps
```
## container
![docker](https://github.com/mrmohsensami/docker/blob/main/img/container.jpg?raw=true "docker")

```docker
docker run -d redis
docker run -itd busybox
docker create --name bx busybox
docker rm bx
docker start bx
docker stop bx
docker restart bx
docker kill bx
docker pause bx
docker unpause bx
docker kill bx
docker rm bx
docker rm -f bx
```
## image layers
![docker](https://github.com/mrmohsensami/docker/blob/main/img/image-layer.jpg?raw=true "docker")

![docker](https://github.com/mrmohsensami/docker/blob/main/img/image-layer2.jpg?raw=true "docker")

![docker](https://github.com/mrmohsensami/docker/blob/main/img/image-layer3.jpg?raw=true "docker")

```docker
docker image inspect python
docker run -itd python
docker exec <container name> ls
docker exec -it <docker name> bash
```
## restart policy
![docker](https://github.com/mrmohsensami/docker/blob/main/img/docker-policy.jpg?raw=true "docker")

```docker
docker container run -it python bash
docker ps
docker container run -itd python bash
docker ps
docker run -it --restart always python bash
exit
docker container inspect <container name>
docker stop ....
```
## Dockerfile
![docker](https://github.com/mrmohsensami/docker/blob/main/img/Dockerfile.jpg?raw=true "docker")

```docker
docker image build -t web:1.0 .
docker run web:1.20
```
## docker push
```docker
docker image tag hello:1.0.0 hacosami/hello:1.0.0
docker push hacosami/hello:1.0.0
docker info =>>> dockerhub
```
## port forwarding
![docker port forwarding](https://github.com/mrmohsensami/docker/blob/main/img/docker-port.jpg "docker port forwarding")

```docker
docker run -d --name rd -p 3030:6379 redis
docker exec -it rd bash

redis-cli
get name
```
## save load
```docker
docker save -o bx.tar busybox:latest
docker load -i bx.tar
```
## commit container layers
![docker commit](https://github.com/mrmohsensami/docker/blob/main/img/docker-commit.jpg "docker commit")

```docker
docker run -itd --name py python
docker diff py
docker container commit py python:one
docker container -a "mohsen" -m "hello.txt" commit py python:one
docker run -itd --name py python:one
docker exec -it py bash
```
## docker volume
![docker volume](https://github.com/mrmohsensami/docker/blob/main/img/docker-volume.jpg "docker volume")

```docker
docker volume prune
docker volume create v1
docker volume inspect v1
docker run -itd --name bx -v v1:/home busybox
docker exec -it bx sh
```
## docker network
![docker network](https://github.com/mrmohsensami/docker/blob/main/img/docker-network.jpg "docker network")

```docker
docker network create abc
docker network ls
docker network inspect abc
docker run -itd --name py python
docker run -itd --name bx busybox
docker network connect abc py
docker network connect abc bx
bx => ping py
```
## docker network
```docker
docker-compose up
docker-compose up -d
```
## docker network
```docker
dockr images --filter "dangling=true"
docker rmi $(docker images -q --filter "dangling=true")
docker rmi hello:1.0
```
## sharing volumes
```docker
docker run -itd --name ap2 --volumes-from ap1 busybox
docker run -itd --name ap3 --volumes-from ap1:ro busybox
```
## dockerizing django
- Create an empty project directory.
- Create a new file called `Dockerfile` in your project directory
- Add the following content to the `Dockerfile`
```
# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
```
- Create a `requirements.txt` in your project directory.
```
Django>=3.0,<4.0
psycopg2>=2.8
```
- Create a file called `docker-compose.yml` in your project directory..
```
version: "3.9"
services:
  db:
    image: postgres
    volumes:
      - ./data/db:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    environment:
      - POSTGRES_NAME=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    depends_on:
      - db
```
- Create the Django project by running the docker-compose run command as follows.
```
sudo docker-compose run web django-admin startproject composeexample .
```
- list the contents of your project
```
ls -l
sudo chown -R $USER:$USER .
ls -l
```
- Connect the database
- In your project directory, edit the `config/settings.py` file.
```
# settings.py
   
import os
   
[...]
   
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('POSTGRES_NAME'),
        'USER': os.environ.get('POSTGRES_USER'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
        'HOST': 'db',
        'PORT': 5432,
    }
}
```

```
docker-compose up -d
```

`` ALLOWED_HOSTS = ['*'] ``

`` docker-compose down ``
