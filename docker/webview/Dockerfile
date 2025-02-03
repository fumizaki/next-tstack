FROM node:22.7-alpine

RUN apk add --no-cache libc6-compat
RUN apk update

WORKDIR /webview
COPY ./app/webview/package.json .

# RUN npm install -g npm@latest
RUN npm install
COPY ./app/webview .
CMD ["npm", "run", "dev"]