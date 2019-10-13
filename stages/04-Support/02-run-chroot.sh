# This runs in context if the image (CHROOT)
# Any native compilation can be done here
# Do not use log here, it will end up in the image

#!/bin/bash

# fix broadcom opengl  library names without breaking anything else
ln -sf /opt/vc/lib/libbrcmEGL.so /opt/vc/lib/libEGL.so
ln -sf /opt/vc/lib/libEGL.so /opt/vc/lib/libEGL.so.1
ln -sf /opt/vc/lib/libbrcmGLESv2.so /opt/vc/lib/libGLESv2.so
ln -sf /opt/vc/lib/libbrcmGLESv2.so /opt/vc/lib/libGLESv2.so.2
ln -sf /opt/vc/lib/libbrcmOpenVG.so /opt/vc/lib/libOpenVG.so
ln -sf /opt/vc/lib/libbrcmWFC.so /opt/vc/lib/libWFC.so

