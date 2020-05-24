set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus-slim
docker build --network=host -t $USERNAME/$IMAGE:latest .
