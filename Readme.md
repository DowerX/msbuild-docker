# MSBuild-docker

## Description
A docker-compose project for building Visual Studio projects under Linux. \
It installs the required dependecies in a Windows VM and then builds an image with wine and the tools required for building.

## Requirements
- a preinstalled Windows VM disk image with some basic post install setup. (See: [dowerx/windows-qemu-docker](https://git.euronetrt.hu/dowerx/windows-qemu-docker))
- the dependencies' setup files. (By default it installs [vs_BuildTools](https://aka.ms/vs/17/release/vs_BuildTools.exe), [Windows SDK](https://go.microsoft.com/fwlink/?linkid=2164145) and [Inno Setup 5.6.1](https://files.jrsoftware.org/is/5/innosetup-5.6.1.exe))
- amd64 CPU with enough cores to handle a VM
- enough RAM to handle a VM
- a lot of disk space:
    - at least a 32 GB Windows VM image (+ overlay at runtime, can be up to 32 GB, but you only need to run this stage once to build the final image)
    - ~8.1 GB build tools
    - ~13.5 GB msbuild docker image
- [KVM](https://www.linux-kvm.org/page/Main_Page) is recommended

## Usage
1. change the path to you Windows disk image in *docker-compose.yml*
2. setup your preferred connfiguration for the VM in *.env.windows*
3. copy your setup files to *build/share*
4. edit *build/share/install-buildtools.ps1* as required
5. run ```docker compose up windows``` to install the buildtools, you can monitor it via VNC on port 5900
6. run ```docker compose build msbuild``` to create the final docker image, you can remove the buildtools from *build/share/msbuild* and *build/share/inno5* afterwards to save space
7. copy your project to the *src* directory
8. run ```docker compose run -it msbuild``` to open a Visual Studio Dev CMD prompt
9. build ;)

## Build environment
- Windows SDK -> Z:\opt\msbuild\winsdk
- vs_BuildTools -> Z:\opt\msbuild\vs_buildtools
- Inno Setup 5 -> C:\Program Files (x86)\Inno Setup 5

## Example build script
*src/build.bat:*
```
set WindowsSdkDir=Z:\opt\msbuild\winsdk
set WindowsSdkVersion=10.0.22621.0

set PATH=Z:\opt\msbuild\vs_buildtools\MSBuild\Current\Bin\;%WindowsSdkDir%\bin\%WindowsSdkVersion%\x64\

msbuild ./project/project.sln ^
    /m:4 ^
    /flp1:logfile=./project/errors.log;errorsonly ^
    /flp2:logfile=./project/warnings.log;warningsonly ^
    /t:Clean;Build ^
    /property:Configuration=Release ^
    /property:WindowsSdkDir=%WindowsSdkDir% ^
    /property:WindowsSdkVersion=%WindowsSdkVersion%
```

## TODO
- reduce images size (use alpine linux, filter wine depedencies)
- automate dependency setup files' downloads
- replace SMB network share with disk image mounting (faster copy/install)
- install qemu userspace and make it run on aarch64