#!/bin/sh
for d in ./*/ ; 
    do (cd "$d" && docker-compose pull && docker-compose up -d); 
done
docker image prune -f
docker builder prune -f