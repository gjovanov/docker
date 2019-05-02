set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=janus
docker build -t $USERNAME/$IMAGE:latest .