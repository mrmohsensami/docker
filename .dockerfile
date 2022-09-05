FROM python:latest

LABEL maintainer="haco.sami@gmail.com"
LABEL version="1.20"

WORKDIR /src

COPY hello.py /src

CMD ["python", "hello.py"]
