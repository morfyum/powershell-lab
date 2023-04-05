#podman run --rm -d --cpus="2" --memory 64M --pids-limit="128" --name mbot.py 000-mbot.py:0.2

#podman run --rm -it --volume powershell:/usr/src/app/ --name pwsh-dev powershell-dev-env:0.2

podman run --rm -it --privileged=true --volume ./src/:/usr/src/app/src --name pwsh-dev powershell-dev-env:0.2

