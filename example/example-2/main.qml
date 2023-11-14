import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

ApplicationWindow {
    id: window

    width: 240; height: 410
    visible: true

    palette {
        text: '#f1f2f3'
        base: '#121314'
        window: '#121314'
        windowText: '#f1f2f3'
        button: '#21a3f1'
        buttonText: '#f1f2f3'
    }

    /// Due to a bug in QML Preview (Hot Reload).
    MainPage {
        anchors.fill: parent
    }
}
