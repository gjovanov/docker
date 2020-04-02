set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=nginx
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
VCS_REF=$(git rev-parse --short HEAD)

printenv

docker build --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg VCS_REF=${VCS_REF} \
  -t $USERNAME/$IMAGE .
