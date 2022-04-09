#!/bin/sh

# Check CPU architecture
ARCH=$(uname -m)

echo -e "${INFO} Check CPU architecture ..."
if [[ ${ARCH} == "x86_64" ]]; then
    BASE_URL="qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip"
elif [[ ${ARCH} == "aarch64" ]]; then
    BASE_URL="qbittorrent-enhanced-nox_aarch64-linux-musl_static.zip"
elif [[ ${ARCH} == "armv7l" ]]; then
    BASE_URL="qbittorrent-enhanced-nox_arm-linux-musleabi_static.zip"
else
    echo -e "${ERROR} This architecture is not supported."
    exit 1
fi

# Download files
echo "Downloading binary file: ${BASE_URL}"
echo "qbittorrent version: ${TAG}"
wget https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/${TAG}/${BASE_URL} -O qbittorrent.zip
unzip qbittorrent.zip -d qbittorrent
mv ./qbittorrent/qbittorrent-nox /usr/bin/qbittorrent-nox
echo "Download binary file: ${ARCH} completed"

# Clean
rm -rf qbittorrent*