#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games
for d in ./repo/containers/*/ ;
    do (cd "$d" && docker-compose pull && docker-compose up -d);
done
docker image prune -f
docker builder prune -f
