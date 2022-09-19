#!/bin/bash
PROJECT="BLE_HID_Client"
ARDDIR=/tmp/acli_${PROJECT}_$$
export ARDUINO_BOARD_MANAGER_ADDITIONAL_URLS="https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json https://m5stack.oss-cn-shenzhen.aliyuncs.com/resource/arduino/package_m5stack_index.json"
export ARDUINO_DIRECTORIES_DATA="${ARDDIR}/data"
export ARDUINO_DIRECTORIES_DOWNLOADS="${HOME}/Sync/ard_staging"
export ARDUINO_DIRECTORIES_USER="${ARDDIR}/user"
export LIBDIR="${ARDUINO_DIRECTORIES_USER}/libraries"
arduino-cli core --no-color update-index
arduino-cli core --no-color install esp32:esp32
arduino-cli core --no-color list
arduino-cli lib --no-color update-index
arduino-cli lib --no-color install "NimBLE-Arduino"
arduino-cli lib --no-color list
#
BOARD="esp32:esp32:esp32"
ln -s ${HOME}/Sync/BLE_HID_Client ${LIBDIR}
alias cc='arduino-cli compile --clean --board-options USBMode=default --fqbn esp32:esp32:esp32s3'
alias up='arduino-cli --fqbn esp32:esp32:esp32s3 upload --port /dev/ttyUSB0'
patch -p2 -d ${ARDUINO_DIRECTORIES_DATA} <sendReport.patch
ctags -R . ${ARDDIR}  ~/Sync/esp-idf/
# Compile all examples for all boards with BLE
declare -A BOARDS=( [esp32:esp32:esp32]="" [esp32:esp32:esp32s3]="--board-options USBMode=default" [esp32:esp32:esp32c3]="" )
for board in "${!BOARDS[@]}" ; do
    export ARDUINO_BOARD_FQBN=${board}
    ARDUINO_BOARD_FQBN2=${ARDUINO_BOARD_FQBN//:/.}
    board_opts=${BOARDS[$board]}
    (find . -name '*.ino' -print0 | xargs -0 -n 1 arduino-cli compile --no-color --verbose --fqbn ${board} ${board_opts} --output-dir "${ARDUINO_BOARD_FQBN2}") >${ARDDIR}/ci_${board}.log 2>&1
done
grep -Ei "^Sketch uses|^Global variables use" ${ARDDIR}/ci_*.log
grep -Ei "^Error|abort|missing|fatal|error:|warning:" ${ARDDIR}/ci_*.log
