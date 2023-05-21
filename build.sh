# Build a new powershell developement environment by a Dockerfile : powershell-dev-env
# Example: powershell-dev-env:0.1

this_version="0.2"

podman build --no-cache --tag powershell-dev-env:$this_version .


echo "*** DONE - LIST IMAGES ***"
podman images
