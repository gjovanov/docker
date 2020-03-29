set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus-simple
docker build -t $USERNAME/$IMAGE:latest .
