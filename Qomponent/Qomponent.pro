TEMPLATE = lib
QT += qml quick quickcontrols2
CONFIG += qt plugin

include(Qomponent.pri)

qmltypes.target = qmltypes
qmltypes.commands = $$[QT_INSTALL_BINS]/qmlplugindump Qomponent 0.1 $$QMAKE_RESOLVED_TARGET > $$PWD/qomponent.qmltypes
qmltypes.depends = $$QMAKE_RESOLVED_TARGET

QMAKE_EXTRA_TARGETS += qmltypes
