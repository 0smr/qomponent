import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

ApplicationWindow {
    id: window

    width: 240; height: 250
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
        width: parent.width
        wrapMode: Text.Wrap
        font.family: Qomponent.monofont.name
        font.pixelSize: 10
        horizontalAlignment: Qt.AlignHCenter
    }

    QtObject {
        id: fonts
        property font icon
        property font mono: Qt.font({family: 'Consolas'})
        property font head: Qt.font({bold: true})
        property font regular
        property font subscript
    }

    QGrid {
        padding: 5
        spacing: 10

        QGrid {
            spacing: 5
            vertical: true
            horizontalItemAlignment: Qt.AlignLeft

            Header { text: 'Theme editor' }

            ThemeEditor {
                id: themeEditor
                target: window
                width: 230; height: 230
                onTempPaletteChanged: save()
            }
        }

        GridSeparator {}

        QGrid {
            spacing: 5
            vertical: true

            Header { text: 'FontSelector' }

            FontSelector {
                width: 225
                height: window.height - 26

                palette.highlight: '#99ffffff'

                target: fonts
                properties: ['icon','mono','head','regular','subscript']
            }
        }

        GridSeparator {}

        QGrid {
            spacing: 5
            vertical: true
            Header { text: 'Offset: ' + linearGauge.offset.toFixed(1) }
            Rectangle { width: 1; height: 4 }
            LinearGauge {
                id: linearGauge
                width: 200; height: 40
                minors: 20
            }

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
        }

        GridSeparator {}

        QGrid {
            vertical: true
            spacing: 5

            Header {
                text: 'Pattern: ' + (pattern.toArray().join(', ') || '-')
            }

            PatternLock {
                id: pattern
                width: 120; height: width
                onRelease: clear()
            }
        }
    }
}
