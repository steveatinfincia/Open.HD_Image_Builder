# Do this to the WORK folder of this stage
pushd ${STAGE_WORK_DIR}

log "Removing old GIT dir"
rm -r GIT || true

mkdir -p GIT

# building outside of GIT so that this giant build tree doesn't get copied into the image
if [ ! -f qt-everywhere-src-5.13.1.tar.xz ]; then
	log "Download Qt 5.13.1"
	wget http://download.qt.io/official_releases/qt/5.13/5.13.1/single/qt-everywhere-src-5.13.1.tar.xz
fi

pushd GIT

MNT_DIR="${STAGE_WORK_DIR}/mnt"

log "Download LiFePO4wered-pi"
git clone https://github.com/xorbit/LiFePO4wered-Pi.git

log "Download Raspi2png"
git clone https://github.com/AndrewFromMelbourne/raspi2png.git

log "Download v4l2loopback"
sudo git clone https://github.com/umlaeute/v4l2loopback.git

log "Download Mavlink router"
sudo git clone -b rock64 https://github.com/user1321/mavlink-router.git
pushd mavlink-router
sudo git submodule update --init

#fix missing pymavlink
pushd modules/mavlink
sudo git clone --recurse-submodules https://github.com/user1321/pymavlink
popd

popd

log "Download cmavnode"
sudo git clone https://github.com/MonashUAS/cmavnode.git
pushd cmavnode
sudo git submodule update --init
popd

#return
popd

