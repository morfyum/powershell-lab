# PowerShell-lab : collection of best practices

This repository is a collection of PowerShell `modules` and `scripts.`

#### Philosophy:

> Installable `powershell` (v6, v7, ...etc) contain some feature which not found in standard windows powershell. Therefore all incompatibility with standard Windows powershell is a `BUG!` Exception to this the flagged scripts.

## Structure

```
.
├── build.sh
├── Dockerfile
├── pwsh.sh
├── README.md
├── run.sh
└── src
    ├── modules
    │   └── module1
    │       └── module1.psm
    └── scripts
        └── ps-app-1
            └── src
                └── modules
```

### Files and folders:
```
build.sh   : Build new docker image
Dockerfile : Basic description of new docker image.
pwsh.sh    : A simple interactive powershell environment.
README.md  : This file
run.sh     : Run interactive shell. (Need to build first!)
src/       : Collection of scirpts and modules
```

> Note: `build.sh` and `run.sh` is contain name and version numbers! You can change it to build and run custom versions.

### ./src/modules/
Collection of different modules. 
This library follow the powershell module standards.

```ps1
# Import powershell module:
Import-Module moduleName.psm
```

### ./src/scripts/
Script directory contain independent scripts in own folder,
which is example, and/or solution for individual problems.

```
ps-app-1/       : The main folder of one powershell scritp.
ps-app-1/src/   : The source library of the script. (script functionality)
ps-app-1/src/modules   : Snapshot of Required modules from root directory.
```

> Modules under `ps-app-1/src/modules` are not guaranteed that contain the latest version of module in root directory.

## Dockerfile & Environment
Extra modules are imported to the interactive shell, for example: `PSScriptAnalyzer` is ready to run with `Invoke-ScriptAnalyzer` command.

### Packages
``` 
  - PSScriptAnalyzer
```

## Setup / Install
Only requirements is Powershell.
All script and module are designed for **Windows** built-in powershell.

### Windows
Required Windows 10 or later. Powershell are pre-installed.
(*Probably scripts are compatible with Windows 7, but its never tested*)

### Linux
You have many options to run powershell on Linux. This repository provides one recommended solution for platform independent developement. This solution is work on any linux distribution when you have `docker` or `podman`

```sh
# Dockerfile is a basic description of recommended container image.
# Use my build script: build.sh

chmod +x ./build.sh
./build.sh

# After a success build, you can run an interactive powershell.
chmod +x ./run.sh
./run.sh
```

### MacOS

```sh
# With brew:
# Install homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install powershell with brew
brew install --cask powershell

# Run Powershell
pwsh

# Update Powershell
brew update
brew upgrade powershell --cask
``` 
