// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qomponent 0.2

ApplicationWindow {
    id: window

    width: 260
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

    component Title: Label {
        color: palette.windowText
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
        property alias cindex: swipview.currentIndex
    }

    PageIndicator {
        x: parent.width - width - 25
        y: parent.height - height - 5
        count: swipview.count
        currentIndex: swipview.currentIndex

        palette.dark: '#fff'
    }

    SwipeView {
        id: swipview
        padding: 5
        spacing: padding
        anchors.fill: parent

        QGrid {
            vertical: true
            spacing: 5

            Title { text: 'MultiRangeSlider' }

            MultiRangeSlider { width: parent.width-20 }

            Title { text: 'TextAnimation' }

            Text {
                id: txt
                width: parent.width
                color: palette.windowText
                text: "Text\nAnimation"
                font.family: Qomponent.monofont.name
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

            Title { text: 'Mini Markdown' }

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
                    <a href='https://0smr.github.io'>link</a>
                    ```
                    let x = 5;
                    code.block;
                    markdown.text();
                    ```
                    + list item 1 `+ one`
                    + list item 2 `+ two`";
            }
        }

        QGrid {
            vertical: true
            spacing: 5

            Title { text: 'Circular Color Picker' }
            Item { width: parent.width; height: 1 }

            CircularColorPicker {
                id: cp
                width: 130; height: width
            }

            Title {
                font.bold: false
                text: cp.color + '\n' +
                      `hsv(${cp.hsvHue.toFixed(2)},` +
                      `${cp.hsvSaturation.toFixed(2)},` +
                      `${cp.hsvValue.toFixed(2)})\n` +
                      `alpha(${cp.hsvAlpha.toFixed(2)})`
            }
        }

        QGrid {
            vertical: true
            spacing: 5

            Title { text: 'UI Tour' }

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

            Column {
                width: parent.width
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
            }


            Title { text: "Tooltips" }

            Title {
                text: "To view the tooltip, hover over the button below."
                opacity: 1; font.bold: false
            }

            Button {
                width: 100; height: 20
                palette.button:'#fb8500'
                text: "Hover me"

                HoverHandler { id: hh }
                ToolTipPlus {
                    x: hh.point.position.x - 20
                    y: hh.point.position.y + 15
                    text: "Hey, I'm Tooltip."
                    delay: 500
                    visible: hh.hovered
                }
            }

            Title { text: "Varaint Spacing Row." }

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
                        margin: 10
                        yAxis.enabled: false
                        xAxis.minimum: 75
                        xAxis.maximum: parent.parent.width
                        cursorShape: Qt.SizeHorCursor
                    }
                }
            }

            Title { text: "Mini Keyboard" }

            QGrid {
                vertical: true
                preferredRows: 2

                component TField: TextField {
                    width: 120; height: 25
                }

                spacing: 4

                MiniKeyboard { enabled: true }

                TField {
                    inputMethodHints: Qt.ImhDigitsOnly
                    placeholderText: "digit only"
                }
                TField {
                    inputMethodHints: Qt.ImhLatinOnly
                    placeholderText: "alphabet only"
                }
                TField {
                    inputMethodHints: Qt.ImhPreferUppercase
                    placeholderText: "prefer uppercase"
                }
                TField {
                    inputMethodHints: Qt.ImhLowercaseOnly
                    placeholderText: "lowercase only"
                }
            }
        }
    }
}
