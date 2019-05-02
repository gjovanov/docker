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
  --rm \
  -p 81:80 \
  -p 444:443 \
  --name="janus" \
  gjovanov/janus
```
