# COTURN docker containers using Mongo Driver for TURN auth


```shell
docker run -d \
        --name="coturn" \
        --net=host \
        --restart="always" \
        gjovanov/coturn \
                -n \
                --log-file=stdout \
                --min-port=49152 --max-port=65535 \
                --listening-ip=your_public_ip \
                --relay-ip=your_public_ip \
                --lt-cred-mech --fingerprint \
                --mongo-userdb="mongodb://mongo_username:mongo_password@url_or_ip:port/coturn" \
                --no-multicast-peers --no-cli \
                --no-tlsv1 --no-tlsv1_1 \
                --realm=mars.xplorify.net
```

```shell
docker run -d \
        --name="coturn" \
        --net=some_network \
        --restart="always" \
        -p 3478:3478 \
        -p 49152-65535:49152-65535/udp \
        gjovanov/coturn \
                -n \
                --log-file=stdout \
                --min-port=49152 --max-port=65535 \
                --listening-ip=your_public_ip \
                --relay-ip=your_public_ip \
                --lt-cred-mech --fingerprint \
                --mongo-userdb="mongodb://mongo_username:mongo_password@url_or_ip:port/coturn" \
                --no-multicast-peers --no-cli \
                --no-tlsv1 --no-tlsv1_1 \
                --realm=mars.xplorify.net
```

