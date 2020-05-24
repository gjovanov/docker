# NGINX with HTTP3
Debian:buster-slim based NGINX image with support:
- HTTP3/quiche
- TLSv1.3
- Brotuli
- BoringSSL
 
```
docker run -d --name nginx \
    --hostname ngin2 \
    --restart always \
    -v /path_to/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /path_to/nginx/conf.d/:/etc/nginx/conf.d/ \
    -v /path_to/nginx/cert/:/etc/nginx/cert/ \
    -v /path_to/nginx/logs/:/etc/nginx/logs/ \
    -p 81:80 \
    -p 444:443 \
    --net=bridge \
    gjovanov/nginx
```
