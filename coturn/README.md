# COTURN docker containers using Mongo Driver for TURN auth


```shell
docker run -d \
	--name="coturn" \
	--net=host \
	--restart="always" \
	-p 3478:3478 \
	-p 49152-65535:49152-65535/udp \
	gjovanov/coturn \
		-n \
		--log-file=stdout \
		--min-port=49152 --max-port=65535 \
		--external-ip=$(detect-external-ip) \
		--relay-ip=$(detect-external-ip) \
		--lt-cred-mech --fingerprint \
		--mongo-userdb="mongodb://mars.xplorify.net:1212/coturn" \
		--no-multicast-peers --no-cli \
		--no-tlsv1 --no-tlsv1_1 \
		--realm=mars.xplorify.net
```
