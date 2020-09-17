# NGINX with HTTP3
Debian:buster-slim based NGINX image with support:
- HTTP3/quiche
- TLSv1.3
- Brotuli
- BoringSSL
 
```
docker run -d --name nginx \
    --hostname nginx \
    --restart always \
    -v /path_to/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /path_to/nginx/conf.d/:/etc/nginx/conf.d/ \
    -v /path_to/nginx/cert/:/etc/nginx/cert/ \
    -v /path_to/nginx/logs/:/etc/nginx/logs/ \
    -v /path_to/geoip/:/usr/share/geoip/ \
    -p 81:80 \
    -p 444:443 \
    gjovanov/nginx
```

# GEO IP
This image includes a copy of the Country GeoLite2 DB:
- **GeoLite2-Country.mmdb**
downloaded from https://dev.maxmind.com/geoip/geoip2/geolite2/

If you want to use also the City GeoLite2 DB:
- **GeoLite2-City.mmdb**

then you need to download it yourself and use a docker volume binding to the local DB copy:
- `-v /path_to/geoip/:/usr/share/geoip/`

## HTTP config example

In your `nginx.conf`:

```conf
load_module modules/ngx_http_geoip2_module.so;


http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;

  # GeoLite2-Country.mmdb is embedded in this docker image
  geoip2 /usr/share/geoip/GeoLite2-Country.mmdb { 
     $geoip2_data_continent_code continent code;
     $geoip2_data_country_code country iso_code;
     $geoip2_data_country_name country names en;
  }

  # GeoLite2-City.mmdb is not embedded in this docker image!!!
  # you can use it only if you download a copy from: https://dev.maxmind.com/geoip/geoip2/geolite2/
  # and start the nginx container with volume bind: -v /path_to/geoip/:/usr/share/geoip/
  geoip2 /usr/share/geoip/GeoLite2-City.mmdb {
     $geoip2_data_city_name city names en;
  }


  log_format  main_geo '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
                       '"$http_user_agent" "$http_x_forwarded_for"'
                       '$geoip2_data_continent_code $geoip2_data_country_code $geoip2_data_country_name $geoip2_data_city_name';

  access_log /var/log/nginx/access.log main_geo;
	
  # OTHER STUFF
 
}
```

## Stream config example:

In your `nginx.conf`

```conf
load_module modules/ngx_stream_geoip2_module.so;

stream {
	 # GeoLite2-Country.mmdb is embedded in this docker image
     geoip2 /usr/share/geoip/GeoLite2-Country.mmdb {
        $geoip2_data_continent_code continent code;
        $geoip2_data_country_code country iso_code;
        $geoip2_data_country_name country names en;
     }

     # GeoLite2-City.mmdb is not embedded in this docker image!!!
     # you can use it only if you download a copy from: https://dev.maxmind.com/geoip/geoip2/geolite2/
     # and start the nginx container with volume bind: -v /path_to/geoip/:/usr/share/geoip/
     geoip2 /usr/share/geoip/GeoLite2-City.mmdb {
        $geoip2_data_city_name city names en;
     }

     log_format  main_geo '$geoip2_data_continent_code $geoip2_data_country_code $geoip2_data_country_name $geoip2_data_city_name';

     access_log /var/log/nginx/access.log main_geo;

	# OTHER STUFF
}
```
