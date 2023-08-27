FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV SOLUTION_DIR=/src
ENV WINEDLLOVERRIDES=mscoree=
ENV WINEDEBUG=-all

RUN \
    sed -i -e "s/main/main contrib/" /etc/apt/sources.list.d/* && \
    apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
        wget ca-certificates && \
    dpkg --add-architecture i386 && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt update && apt install -y --install-recommends \
        winehq-stable winetricks winbind && \
    apt remove --autoremove -y \
        wget ca-certificates && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN \
    wineboot --init && \
    winetricks --force --unattended dotnet48 win10 && \
    wineserver --kill; exit 0

COPY bin /usr/bin

COPY share/msbuild /opt/msbuild
RUN sed -i 's/\"!result:~0,3!\"==\"10.\"/\"1\"==\"1\"/g' /opt/msbuild/vs_buildtools/Common7/Tools/vsdevcmd/core/winsdk.bat

COPY [ "share/inno5", "/root/.wine/drive_c/Program Files (x86)/Inno Setup 5" ]

WORKDIR /src
ENTRYPOINT ["vs_cmd"]
CMD ["cmd"]