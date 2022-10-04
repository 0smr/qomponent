import QtQuick 2.15

Rectangle {
    id: ctrl
    anchors.fill: parent

    property bool e: true
    property int r: 1
    property int c: 1

    color: 'transparent'
    enabled: e
    border {
        width: 0.8
        color: palette.windowText
    }

    onWidthChanged: text.visible = enabled
    onHeightChanged: text.visible = enabled

    Rectangle {
        id: text
        x: (ctrl.width - width) * (ctrl.r / 2)
        y: (ctrl.height - height) * (ctrl.c / 2)
        width: childrenRect.width
        height: childrenRect.height
        visible: true; opacity: 0.7; radius: 3

        Text { text: "w: %1\nh: %2".arg(ctrl.width).arg(ctrl.height); font.pixelSize: 10; padding: 3 }
        Timer { running: parent.visible; interval: 500; onTriggered: parent.visible = false }
    }
}
