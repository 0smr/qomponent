import QtCore
import QtQuick
import QtQuick.Controls.Basic

import qomponent

Page {
    id: root

    implicitWidth: 240
    implicitHeight: 430

    palette {
        button: "#4af"
        buttonText: "#fff"
        highlight: "#57f"
        highlightedText: "#fff"

        base: "#1d1c21"
        text: "#eee"
        window: '#1d1c21'
        windowText: "#eee"
        placeholderText: '#eee'
    }

    component Header: Label {
        topPadding: 10
        wrapMode: Text.Wrap
        font.pixelSize: 10
        font.family: Qomponent.monofont.name
        horizontalAlignment: Qt.AlignHCenter
    }

    component NumInput: TextField {
        padding: 6; leftPadding: 6; rightPadding: 6
        font.bold: true
        text: '00'

        inputMask: '99'
        selectByMouse: true
        selectionColor: '#ccc'

        cursorDelegate: Component{Item{}}
        horizontalAlignment: Qt.AlignHCenter

        background: Rectangle {
            radius: 3
            color: 'transparent'
            border.color: parent.color
            opacity: 0.5 + 0.5 * parent.activeFocus
        }
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
        count: swipeview.count
        currentIndex: swipeview.currentIndex

        palette.dark: '#fff'
    }

    Settings {
        location: 'conf.ini'
        property alias cindex: swipeview.currentIndex
    }

    SwipeView {
        id: swipeview
        currentIndex: 0
        padding: 5; spacing: 5
        anchors.fill: parent

        QGrid {
            spacing: 5
            vertical: true
            Item { width: parent.width; height: 1 }

            Header { text: 'Time Picker' }
            Row {
                bottomPadding: 10
                spacing: 2
                NumInput { id: hourInput }
                Label { topPadding: 5; text: ':' }
                NumInput { id: minuteInput }
            }

            TimePicker {
                width: 150; height: 150
                model: 24
                palette.highlight: '#000'
                onValueChanged: {
                    const hour = hourInput, min = minuteInput;
                    if(hour.activeFocus) hour.text = String(value % 24).padStart(2,0);
                    if(min.activeFocus) min.text = String(value).padStart(2,0);
                }
            }

            Header { text: 'Bar Chart' }

            Column {
                spacing: 5

                Row {
                    spacing: 5
                    SimpleButton {
                        text: 'clear'
                        onClicked: barchart.model.clear()
                    }

                    SimpleButton {
                        id: resumebtn
                        text: checked ? 'start' : 'stop'
                        checkable: true
                    }

                    Header {
                        topPadding: 0
                        text: 'model.count: ' + barchart.model.count
                    }
                }

                BarChart {
                    id: barchart
                    size: 10000

                    Timer {
                        running: resumebtn.checked
                        repeat: true
                        interval: 1
                        property int i: 0
                        onTriggered: parent.model.append({value: Math.sin(0.05 * i++)/2 + 0.5});
                    }
                }
            }
        }

        QGrid {
            spacing: 5
            vertical: true
            Item { width: parent.width; height: 1 }

            Header { text: 'Rectangle' }

            Grid {
                spacing: 5
                Repeater {
                    model: [[0, 3, 5, 10], [5, 15, 0, 10], [10, 5], 12,
                            [0, 3, 5, 10], [5, 15, 0, 10], [10, 5], 12]

                    QRect {
                        required property int index;
                        required property var modelData;

                        width: 20; height: 20
                        color: index >= 4 ? 'transparent' : '#fff'
                        stroke: '#21a3f1'
                        strokeWidth: index >= 4 ? 1 : 0
                        radius: {
                            if(typeof modelData !== 'number') {
                                const [x,y,z,w] = modelData;
                                return {x,y,z,w};
                            } else {
                                return modelData;
                            }
                        }
                    }
                }
            }

            Header { text: 'Elastic animation' }

            Header {
                text: 'Qomponent'
                width: parent.width
                font.pixelSize: 25
                layer.enabled: true
                layer.effect: ElasticEffect {
                    NumberAnimation on bend {
                        running: elasticAnim.running
                        from: 0.5; to: 0
                        easing.type: Easing.OutElastic
                        duration: 2000
                    }
                }

                SequentialAnimation on x {
                    id: elasticAnim
                    NumberAnimation {
                        from: -100; to: 0; duration: 200
                        easing.type: Easing.OutExpo
                    }
                    PauseAnimation { duration: 2000 - 200 }
                }
            }

            SimpleButton {
                text: 'run'
                enabled: !elasticAnim.running
                onClicked: elasticAnim.start();
            }
        }

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
                target: root
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

            Header { text: 'Pattern: ' + (pattern.toArray().join(', ') || '-') }

            PatternLock {
                id: pattern
                width: 100; height: width
                onRelease: clear()
            }
        }

        QGrid {
            spacing: 10
            vertical: true
            Item { width: parent.width; height: 1 }

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
