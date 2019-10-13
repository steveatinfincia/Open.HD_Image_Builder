# Do this to the WORK folder of this stage
pushd ${STAGE_WORK_DIR}

MNT_DIR="${STAGE_WORK_DIR}/mnt"

log "Building Qt"

#apt purge -y libx11-xcb-dev libgbm-dev libxcb-xfixes0-dev libxcb-glx0-dev libsm-dev libxkbcommon-x11-dev libgtk-3-dev libwayland-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libxcb-sync-dev libxcb-randr0-dev libxcb-icccm4-dev
apt install libspeechd-dev flite1-dev flite speech-dispatcher-flite --no-install-recommends

wget https://raw.githubusercontent.com/Kukkimonsuta/rpi-buildqt/master/scripts/utils/sysroot-relativelinks.py

chmod +x sysroot-relativelinks.py

./sysroot-relativelinks.py ${MNT_DIR}

if [ ! -d ${STAGE_WORK_DIR}/qt5pi ]; then

	# blow away the old directory to guarantee clean source state
	if [ -d qt-everywhere-src-5.13.1 ]; then
		rm -rf qt-everywhere-src-5.13.1
	fi

	tar xvf qt-everywhere-src-5.13.1.tar.xz

	cd qt-everywhere-src-5.13.1

	LIBS=-ldl ./configure \
-release \
-opengl es2 \
-device linux-rasp-pi-g++ \
-device-option CROSS_COMPILE=${HOME}/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- -no-use-gold-linker \
-sysroot ${MNT_DIR} \
-opensource \
-confirm-license \
-make libs \
-prefix /usr/local/qt5pi \
-extprefix ${STAGE_WORK_DIR}/qt5pi \
-hostprefix ${STAGE_WORK_DIR}/qt5 \
-v \
-skip qtcharts \
-skip qtdatavis3d \
-skip qtwayland \
-skip qtwebengine \
-skip qtconnectivity \
-skip qtlocation \
-skip qtxmlpatterns \
-skip qtsensors \
-skip qtpurchasing \
-skip qtnetworkauth \
-skip qtwebchannel \
-skip qtwebsockets \
-skip qtwebview \
-no-feature-sql \
-no-feature-cups \
-no-feature-testlib \
-no-feature-dbus \
-no-feature-vnc \
-no-sql-sqlite \
-no-compile-examples \
-no-feature-xlib \
-no-xcb

	make -j5
	make -j5 install
	cd ..

	cp -r qt5pi "$MNT_DIR/usr/local/"

fi #if ! qt5pi

log "Download QOpenHD"

# blow away the old directory to guarantee clean source state
if [ -d QOpenHD ]; then
        rm -rf QOpenHD
fi

#git clone https://github.com/infincia/QOpenHD.git
cp -a /media/psf/SourceCache/openhd/QOpenHD QOpenHD
cd QOpenHD
${STAGE_WORK_DIR}/qt5/bin/qmake
make -j5
cp -a release/QOpenHD "${MNT_DIR}/usr/local/bin/QOpenHD"
cd ..


#return
popd
