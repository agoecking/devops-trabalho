FROM node:18-alpine

WORKDIR /
COPY package*.json ./
RUN npm install
COPY . .
CMD ["node", "app.js"]

EXPOSE 8080