set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus-alpine
docker build -t $USERNAME/$IMAGE:latest .
