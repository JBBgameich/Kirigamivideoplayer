TEMPLATE = app

QT += qml quick 
#svg sql webkit multimedia

SOURCES += src/main.cpp

RESOURCES += vplayer.qrc

TEMPLATE = app
TARGET = vplayer

target.path = /usr/bin
INSTALLS += target

icon.path = /usr/share/icons/hicolor/scalable/apps/
icon.files = icons/$${TARGET}.svg
INSTALLS += icon

desktopfile.path = /usr/share/applications
desktopfile.files = $${TARGET}.desktop
INSTALLS += desktopfile
