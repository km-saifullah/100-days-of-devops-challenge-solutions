sudo su -

docker network create \
--driver bridge \
--subnet 172.28.0.0/24 \
--ip-range 172.28.0.0/24 \
beta

docker network ls

docker network inspect beta