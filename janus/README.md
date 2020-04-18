# Docker build Janus
`docker build -t gjovanov/janus .`


# Docker run Janus
```docker
docker run \
  --rm \
  -p 81:80 \
  -p 444:443 \
  --net="host" \
  --name="janus" \
  -it \
  -t gjovanov/janus \
  /bin/bash
```

```docker
docker run \
  -p 81:80 \
  -p 444:443 \
  --name="janus" \
  --restart="always" \
  --network="nginx" \
  -v /path_to/xplorify.net.pem:/usr/local/nginx/server.crt \
  -v /path_to/xplorify.net.key:/usr/local/nginx/server.key \
  -v /path_to/log_janus:/app/log \
  gjovanov/janus
```
