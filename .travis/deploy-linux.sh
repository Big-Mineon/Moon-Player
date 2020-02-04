#!/bin/sh

# Run make install
make install DESTDIR=appdir
find appdir/

# Create appimage
curl -Lo linuxdeployqt.AppImage "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt.AppImage
./linuxdeployqt.AppImage appdir/usr/share/applications/*.desktop -appimage -qmldir=src/qml/