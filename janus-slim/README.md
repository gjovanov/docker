# Lean Janus Gateway Docker image based on Buster-Slim

# How to use it

## Recommended on host network

```docker
docker run -d \
  --name="janus" \
  --restart="always" \
  --network="host" \
  gjovanov/janus-slim
```

## Alternatively behind 

```docker
docker run -d \
  -p 81:80 \
  -p 444:443 \
  --name="janus" \
  --restart="always" \
  --network="my_net" \
  gjovanov/janus-slim
```

```docker
docker run \
  -p 81:80 \
  -p 444:443 \
  --name="janus" \
  --restart="always" \
  --network="my_net" \
  -v /path_to/cert/domain.pem:/usr/local/nginx/server.crt \
  -v /path_to/cert/domain.key:/usr/local/nginx/server.key \
  -v /path_to/log_janus:/app/log \
  gjovanov/janus-slim
```

