#! /bin/bash

user=quinn
email=quinn@example.org

#docker-compose -f fin-example.yml up -d

docker-compose -f fin-example.yml exec basic-auth node service/cli create-user -u $user -p laxlax -e $email

docker-compose -f fin-example.yml exec server node app/cli admin add-admin -u ${user}@local

# Mint a token
source fin-example.env; fin jwt encode --admin --save=true $JWT_SECRET $JWT_ISSUER ${user}@local

fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ server.ttl -P h /
fin http get -P b /
