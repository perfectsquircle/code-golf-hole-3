# docker build -t golf .
# docker run -it -v "$PWD":/tmp/src golf bash

From node

RUN apt-get update
RUN apt-get install -y ruby
RUN apt-get install -y python3
COPY . /src/
WORKDIR /src
