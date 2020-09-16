set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=nginx
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
VCS_REF=$(git rev-parse --short HEAD)

printenv


# tag it
git add -A
git commit -m "$IMAGE $version"
git tag -a "$IMAGE_$version" -m "$IMAGE version $version"
git push
git push --tags
