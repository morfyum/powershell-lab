#podman run --rm -d --cpus="2" --memory 64M --pids-limit="128" --name mbot.py 000-mbot.py:0.2

podman run --rm -it --volume powershell:/usr/src/app/mount --name pwsh-dev powershell-dev-env:0.2
