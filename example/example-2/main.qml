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

    component Header: Label {
        topPadding: 10
        width: parent.width
        wrapMode: Text.Wrap
        font.pixelSize: 10
        font.family: Qomponent.monofont.name
        horizontalAlignment: Qt.AlignHCenter
    }

    component SimpleButton: RoundButton {
        width: 40; height: 16
        radius: 2; padding: 0
        palette.mid: '#999'
        palette.button: '#fff'
        palette.buttonText: '#123'
    }

    component SimpleCheck: CheckBox {
        padding: 0; height: 16
        indicator: Control {
            width: 16; height: 16
            padding: 2 + 6 * !parent.checked
            focusPolicy: Qt.NoFocus
            contentItem: Rectangle { radius: 2; color: '#ddd' }
            background: Rectangle {
                radius: 3
                color: 'transparent'
                border.color: '#aaa'
            }
            Behavior on padding {NumberAnimation{}}
        }
    }

    QtObject {
        id: fonts
        property font icon
        property font mono: Qt.font({family: 'Consolas'})
        property font head: Qt.font({bold: true})
        property font regular
        property font subscript
    }

    PageIndicator {
        x: (parent.width - width)/2
        y: parent.height - height - 10
        count: swipview.count
        currentIndex: swipview.currentIndex

        palette.dark: '#fff'
    }

    SwipeView {
        id: swipview
        currentIndex: 0
        padding: 5; spacing: 5
        anchors.fill: parent

        QGrid {
            spacing: 5
            vertical: true

            Header { text: 'Theme editor' }

            Row {
                spacing: 10
                width: parent.width

                SimpleCheck { id: checkbox; text: 'minibox' }
                SimpleCheck { id: liveedit; text: 'live edit' }

                SimpleButton {
                    text: 'save'
                    visible: !liveedit.checked && themeEditor.target.palette !== themeEditor.bufferPalette
                    onClicked: themeEditor.save();
                }
            }

            ThemeEditor {
                id: themeEditor
                target: window
                width: parent.width; height: 230
                minibox: checkbox.checked
                onBufferPaletteChanged: liveedit.checked && save()
            }
        }

        QGrid {
            spacing: 5
            vertical: true

            Header { text: 'FontSelector' }

            FontSelector {
                width: parent.width
                height: 200

                palette.highlight: '#99ffffff'

                target: fonts
                properties: ['icon','mono','head','regular','subscript']
            }

            Header {
                text: 'Pattern: ' + (pattern.toArray().join(', ') || '-')
            }

            PatternLock {
                id: pattern
                width: 100; height: width
                onRelease: clear()
            }
        }

        QGrid {
            spacing: 10
            vertical: true

            Header { text: 'Offset: ' + ['x','y'].map(v => gruler.offset[v].toFixed(1)).join(', ') }

            GridRuler {
                id: gruler; width: 150; height: width
                background: Rectangle {
                    color: 'transparent'
                    border.color: '#fff'
                    border.width: 0.5
                    opacity: 0.1
                }
            }

            Header { text: 'Offset: ' + linearGauge.offset.toFixed(1) }

            Rectangle { width: 1; height: 4 }
            LinearGauge {
                id: linearGauge
                width: parent.width - 20; height: 40
                minors: 20
            }
        }
    }
}
