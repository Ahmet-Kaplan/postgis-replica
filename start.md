
docker network create --driver=overlay traefik-public

export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

export EMAIL=admin@example.com

export DOMAIN=traefik.sys.example.com

export USERNAME=admin

export PASSWORD=changethis

export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)

docker swarm init --advertise-addr 192.168.14.105

docker swarm join-token manager

docker swarm join-token worker

docker stack deploy -c traefik-stack.yml traefik


export DOMAIN=swarmpit.sys.example.com
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add swarmpit.db-data=true $NODE_ID
docker node update --label-add swarmpit.influx-data=true $NODE_ID

docker stack deploy -c swarmpit.yml swarmpit
