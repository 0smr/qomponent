import QtQuick
import QtQuick.Controls.Basic

import qomponent

ApplicationWindow {
    id: window
    width: 280
    height: 460
    visible: true

    GridRuler {
        anchors.centerIn: parent

        width: 200
        height: 200

        origin: 'red'
        color: '#21a3f1'
    }
}
