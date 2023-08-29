import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import Qomponent 0.1

ApplicationWindow {
    id: window
    width: 200
    height: 200
    visible: true

    color: '#121314'
    palette.windowText: '#f1f2f3'

    GridRuler {
        x: (parent.width - width)/2
        y: (parent.height - width)/2

        width: 100
        height: 100
    }
}
