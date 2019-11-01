FROM node:12.13.0
EXPOSE 3000
WORKDIR /app
ADD package.json yarn.lock /app/
RUN yarn
ADD . /app
CMD yarn start
