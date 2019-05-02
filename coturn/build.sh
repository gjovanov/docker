set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=coturn
docker build -t $USERNAME/$IMAGE:latest .