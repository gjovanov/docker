#!/bin/bash

# If command starts with an option, prepend with turnserver binary.
if [ "${1:0:1}" == '-' ]; then
  set -- /opt/coturn/turnserver "$@"
fi

exec $(eval "echo $@")
