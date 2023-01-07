import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qomponent 0.1

ApplicationWindow {
    id: window

    property real pagewidth: 255

    width: pagewidth
    height: 420
    visible: true

    palette {
        button: "#4af"
        buttonText: "#fff"
        highlight: "#57f"
        highlightedText: "#fff"

        base: "#1d1c21"
        text: "#eee"
        window: '#1d1c21'
        windowText: "#eee"
    }

    component ButtonColor: Button {
        width: 20; height: width; text: '\u2022'
        onClicked: {
            window.palette.button = palette.button
            window.palette.buttonText = palette.buttonText
            window.palette.highlight = palette.button
            window.palette.highlightedText = palette.buttonText
        }
    }

    component BackColor: Button {
        width: 20; height: width; text: '\u2022'
        onClicked: {
            window.palette.base = palette.button
            window.palette.text = palette.buttonText
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
        x: 5; y: window.height - height - 10; z: 3
        padding: 5
        background: Rectangle { color: palette.windowText; opacity: 0.2; radius: 3 }
        contentItem: Row {
            spacing: 4
            ButtonColor { palette { button:'#48abff';buttonText:'#1d1c21' }}
            ButtonColor { palette { button:'#edc9aa';buttonText:'#1d1c21' }}
            ButtonColor { palette { button:'#4ce0b3';buttonText:'#1d1c21' }}
            ButtonColor { palette { button:'#1d1c21';buttonText:'#f5f6f7' }}
            Item { width: 4; height: parent.height }
            BackColor { palette { button: '#f5f6f7'; buttonText:'#1d1c21' }}
            BackColor { palette { button: '#1d1c21'; buttonText:'#f5f6f7' }}
        }
    }

    Settings {
        id: settings
        fileName: 'config.conf'
        property real xscroll: flickable.xscroll
    }

    Flickable {
        id: flickable

        property real xscroll: ScrollBar.horizontal.position
        Component.onCompleted: ScrollBar.horizontal.position = settings.xscroll

        anchors.fill: parent
        interactive: false
        ScrollBar.horizontal: ScrollBar {}

        contentWidth: grid.width
        contentHeight: height

        Grid {
            id: grid
            padding: 5
            spacing: 5
            width: children.width
            height: window.height
            flow: Grid.LeftToRight

            Column {
                width: pagewidth - 10; spacing: 5

                Title {
                    text: 'MultiRangeSlider'
                    width: parent.width
                }

                MultiRangeSlider {
                    width: parent.width-1
                }

                Title {
                    text: 'TextAnimation'
                    width: parent.width
                }

                Text {
                    id: txt
                    width: parent.width
                    color: palette.windowText
                    text: "Text\nAnimation"
                    font.family: 'consolas'
                    horizontalAlignment: Text.AlignHCenter
                }

                TextAnimation {
                    id: tanim
                    target: txt
                    property: "text"
                    duration: 1000
                }

                Timer {
                    property int idx: 0
                    running: !tanim.running; repeat: true; interval: 5000
                    onTriggered: {
                        const strs = ["First, solve the problem.\n Then, write the code. (John Johnson)",
                                      "Test for TextAnimation Component.\n(SMR)",
                                      "Good code is its own best documentation.\n(Steve McConnell)",
                                      "Knowledge is power.\n(Francis Bacon)"]
                        tanim.to = strs[idx];
                        idx = (idx + 1) % 4;
                        tanim.restart();
                    }
                }

                Title {
                    text: 'Mini Markdown'
                    width: parent.width
                }

                MiniMarkdown {
                    width: parent.width
                    trimStart: true
                    text: "
                        # h1
                        ## h2
                        ### h3
                        #### h4
                        normal-text *italic* **bold**<br>
                        ***bold-italic*** `inline code`<br>
                        <a href='https://smr76.github.io'>link</a>
                        ```
                        let x = 5;
                        code.block;
                        markdown.text();
                        ```
                        + list item 1 `+ one`
                        + list item 2 `+ two`";
                }
            }

            GridSeparator {}

            Column {
                width: pagewidth - 10; spacing: 5

                Title {
                    text: 'Circular Color Picker'
                    width: parent.width
                }

                Title {
                    text: cp.color + '\n' +
                          `hsv(${cp.hsvHue.toFixed(2)},` +
                          `${cp.hsvSaturation.toFixed(2)},` +
                          `${cp.hsvValue.toFixed(2)})\n` +
                          `alpha(${cp.hsvAlpha.toFixed(2)})`
                    width: parent.width
                }

                CColorPicker { id: cp; x: 15; width: parent.width - 30; height: width }
            }

            GridSeparator {}

            Column {
                width: pagewidth - 10; spacing: 5
                Title {
                    text: 'UI Tour'
                    width: parent.width
                }

                UITour {
                    id: uitour
                    UITourItem {
                        target: target1; align: Qt.AlignRight // default also is left
                        text: "Please click here (Button)"
                    }
                    UITourItem {
                        target: target2; align: Qt.AlignLeft
                        text: "Please click here (Button 2)"
                    }
                }

                Row {
                    spacing: 5
                Button {
                    width: 50; height: 20
                    text: 'start'
                        onClicked: uitour.start(0);
                    }

                    Button {
                        checkable: true
                        width: 120; height: 20
                        text: 'exnternal window'
                        onClicked: uitour.external = checked;
                    }
                }

                Button {
                    id: target1
                    width: 20; height: 20
                    palette.button:'#2eb840'
                }

                Button {
                    id: target2
                    x: parent.width - width
                    width: 20; height: 20
                    palette.button:'#f8d714'
                }

                Title {
                    width: parent.width
                    text: "Tooltips"
                }

                Title {
                    width: parent.width
                    text: "To view the tooltip, hover over the button below."
                    opacity: 1; font.bold: false
                }

                Button {
                    width: 100; height: 20
                    palette.button:'#fb8500'
                    text: "Hover me"

                    HoverHandler { id: hh }
                    WToolTip {
                        x: hh.point.position.x - 20
                        y: hh.point.position.y + 15
                        text: "Hey, I'm Tooltip."
                        delay: 1500
                        visible: hh.hovered
                    }
                }

                Title {
                    width: parent.width
                    text: "Varaint Spacing Row."
                }

                Title {
                    text: "(Drag the Handle)"
                    opacity: 1; font.bold: false
                }

                Item {
                    width: parent.width; height: 50

                    VRow {
                        id: vsrow
                        height: parent.height; width: xhandle.x - 5
                        Rectangle { width: 25; height: 25; color: '#8338ec' }
                        Rectangle { width: 25; height: 25; color: '#f6bd60' }
                        Rectangle { width: 25; height: 25; color: '#f28482' }
                    }

                    Row {
                        height: parent.height; width: xhandle.x - 5
                        Item { width:25; height:5 }
                        Title { width: vsrow.spacing; text: width.toFixed(); opacity: 1; font.bold: false }
                        Item { width:25; height:5 }
                        Title { width: vsrow.spacing; text: width.toFixed(); opacity: 1; font.bold: false }
                        Item { width:25; height:5 }
                    }

                    Rectangle { id: xhandle
                        x: 100
                        width: 5; height: parent.height; radius: 5
                        color: '#84a59d'
                        DragHandler {
                            yAxis.enabled: false
                            xAxis.minimum: 75
                            xAxis.maximum: parent.parent.width
                            cursorShape: Qt.SizeHorCursor
                        }
                    }
                }
            }
        }
    }
}
