set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus-alpine
docker build --network=host -t $USERNAME/$IMAGE:latest .
