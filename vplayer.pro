TEMPLATE = app

QT += qml quick svg sql webkit multimedia

SOURCES += src/main.cpp

RESOURCES += vplayer.qrc

TEMPLATE = app
TARGET = vplayer

target.path = /usr/bin
INSTALLS += target

icon.path = /usr/share/icons/hicolor/scalable/apps/
icon.files = data/icons/$${TARGET}.svg
INSTALLS += icon

desktopfile.path = /usr/share/applications
desktopfile.files = $${TARGET}.desktop
INSTALLS += desktopfile

# QtMpris
MPRISQTLIB = mpris-qt5

INCLUDEPATH += $$[QT_INSTALL_HEADERS]/MprisQt
LIBS += -L$$[QT_INSTALL_LIBS] -l$${MPRISQTLIB}
PKGCONFIG = dbusextended-qt5

CONFIG += qt link_pkgconfig
