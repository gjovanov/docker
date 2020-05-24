set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus-full
docker build -t $USERNAME/$IMAGE:latest .
