QT += qml quick core gui sql

CONFIG += c++17

TARGET = reliability
TEMPLATE = app

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp \
        logincontroller.cpp \
        db/sqlconnection.cpp

HEADERS += \
        logincontroller.h \
        db/sqlconnection.h

RESOURCES += qml.qrc

# Default rules for deployment.
target.path = $$[QT_INSTALL_BINS]
INSTALLS += target
