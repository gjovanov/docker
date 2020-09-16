set -ex
# SET THE FOLLOWING VARIABLES
USERNAME=gjovanov
IMAGE=nginx

printenv


# tag it
git add -A
git commit -m "$IMAGE $version"
git tag -a "$IMAGE_$version" -m "$IMAGE version $version"
git push
git push --tags
