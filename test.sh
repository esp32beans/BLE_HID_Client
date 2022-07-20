#!/bin/bash
PROJECT="BLE_HID_Client"
IDEVER="1.8.19"
machine=`uname -m`
if [[ $machine =~ .*armv.* ]] ; then
    WORKDIR="/var/tmp/autobuild_${PROJECT}_$$"
    ARCH="linuxarm"
elif [[ $machine =~ .*aarch64.* ]] ; then
    WORKDIR="/var/tmp/autobuild_${PROJECT}_$$"
    ARCH="linuxaarch64"
else
    WORKDIR="/tmp/autobuild_${PROJECT}_$$"
    ARCH="linux64"
fi
mkdir -p ${WORKDIR}
# Install Ardino IDE in work directory
if [ ! -f ~/Downloads/arduino-${IDEVER}-${ARCH}.tar.xz ]
then
    wget https://downloads.arduino.cc/arduino-${IDEVER}-${ARCH}.tar.xz
    mv arduino-${IDEVER}-${ARCH}.tar.xz ~/Downloads
fi
tar xf ~/Downloads/arduino-${IDEVER}-${ARCH}.tar.xz -C ${WORKDIR}
# Create portable sketchbook and library directories
IDEDIR="${WORKDIR}/arduino-${IDEVER}"
LIBDIR="${IDEDIR}/portable/sketchbook/libraries"
mkdir -p "${LIBDIR}"
export PATH="${IDEDIR}:${PATH}"
cd ${IDEDIR}
which arduino
unzip -d ./tools ~/Downloads/EspExceptionDecoder-2.0.2.zip
if [ -d ~/Sync/ard_staging ]
then
    ln -s ~/Sync/ard_staging ${IDEDIR}/portable/staging
fi
arduino --pref "compiler.warning_level=default" \
    --pref "update.check=false" \
    --pref "editor.external=true" \
    --save-prefs
arduino --pref "boardsmanager.additional.urls=https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json,https://m5stack.oss-cn-shenzhen.aliyuncs.com/resource/arduino/package_m5stack_index.json" --save-prefs
arduino --install-boards "m5stack:esp32"
arduino --install-boards "esp32:esp32:2.0.3"
arduino --install-boards "esp32:esp32:2.0.3"
BOARD="esp32:esp32:esp32"
arduino --board "${BOARD}" --save-prefs
CC="arduino --verify --board ${BOARD}"
arduino --install-library "NimBLE-Arduino"
ln -s ~/Sync/${PROJECT} ${LIBDIR}/..
cd ${IDEDIR}
ctags -R . ~/Sync/esp-idf
git init
echo -e "*.gz\n*.bz2\n*.tgz\n*.zip\njava/\ntools/\ntools-builder/" >.gitignore
git add .
git commit -m "First draft"
