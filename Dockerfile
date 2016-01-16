# from ubuntu
FROM ubuntu:14.04

# Get Nodejs
FROM node:5.3.0


RUN apt-get update

# install nodejs and npm
RUN apt-get install -y nodejs npm

# add documents
ADD . /srv/mosca_server

# set workdir
WORKDIR /srv/mosca_server

# install npm packages
RUN npm install mosca --save
#RUN npm install redis --save
RUN npm install cluster --save



# expose the port 1883 and 80
EXPOSE 80
EXPOSE 1883


CMD ["nodejs", "/srv/mosca_server/index"]

