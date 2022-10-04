import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qomponent 0.1

ApplicationWindow {
    id: window

    width: 260
    height: 420
    visible: true

    palette {
        base: "#48abff"
        text: "#eee"

        button: "#48abff"
        buttonText: "#fff"
        highlight: "#5c75f4"
        highlightedText: "#fff"

        window: '#1d1c21'
        windowText: "#eee"
    }

    component ButtonColor: Button {
        width: 20; height: width; text: '\ue000'
        font.family: 'knight'
        onClicked: {
            window.palette.base = palette.button
            window.palette.text = palette.buttonText
            window.palette.button = palette.button
            window.palette.buttonText = palette.buttonText
            window.palette.highlight = Qt.darker(palette.button, 1.5)
        }
    }

    component BackColor: Button {
        width: 20; height: width; text: '\ue000'
        font.family: 'knight'
        onClicked: {
            window.palette.window = palette.button
            window.palette.windowText = palette.buttonText
        }
    }

    component Title: Text {
        color: palette.windowText
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        opacity: 0.3
    }

    component HLine: Rectangle {
        color: palette.windowText
        width: parent && parent.width
        opacity: 0.3
    }

    Control {
        x: 5; y: window.height - height - 5; z: 3
        padding: 5
        background: Rectangle { color: palette.windowText; opacity: 0.2; radius: 3 }
        contentItem: Row {
            spacing: 4
            ButtonColor { palette { button:'#48abff';buttonText:'#1d1c21' }}
            ButtonColor { palette { button:'#edc9aa';buttonText:'#1d1c21' }}
            ButtonColor { palette { button:'#343536';buttonText:'#f5f6f7' }}
            Item { width: 4; height: parent.height }
            BackColor { palette { button: '#f5f6f7'; buttonText: '#1d1c21' }}
            BackColor { palette { button: '#1d1c21'; buttonText: '#f5f6f7' }}
        }
    }

    Grid {
        padding: 5
        spacing: 5
        width: 780; height: window.height

        Column {
            width: 250; spacing: 5

            Title {
                text: 'MultiRangeSlider'
                width: parent.width
            }

            MultiRangeSlider {
                width: parent.width
            }

            Title {
                text: 'Behavior on Text'
                width: parent.width
            }

            Text {
                id: txt
                color: palette.windowText
                text: "Sample"
                font.family: 'consolas'

                TextAnimation {
                    id: tanim
                    property int idx: 0
                    target: txt
                    property: "text"
                    duration: 1000
                    to: ["this is","a sample text",
                         "to show have TextAnimation works."][idx]
                }

                Timer {
                    running: true; repeat: true; interval: 2100
                    onTriggered: {
                        tanim.restart();
                        tanim.idx = (tanim.idx+1)%3;
                    }
                }
            }
        }
    }
}
