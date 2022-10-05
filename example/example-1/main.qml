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

        button: "#48abff"
        buttonText: "#fff"
        highlight: "#5c75f4"
        highlightedText: "#fff"

        base: "#1d1c21"
        text: "#eee"
        window: '#1d1c21'
        windowText: "#eee"
    }

    component ButtonColor: Button {
        width: 20; height: width; text: '\ue000'
        font.family: 'knight'
        onClicked: {
            window.palette.button = palette.button
            window.palette.buttonText = palette.buttonText
            window.palette.highlight = Qt.darker(palette.button, 1.5)
        }
    }

    component BackColor: Button {
        width: 20; height: width; text: '\ue000'
        font.family: 'knight'
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
        flow: Grid.LeftToRight

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
                text: 'TextAnimation'
                width: parent.width
            }

            Text {
                id: txt
                width: parent.width
                color: palette.windowText
                text: "Text Animation"
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
                text: "# h1\n" +
                      "## h2\n" +
                      "### h3\n" +
                      "#### h4\n" +
                      "<a href='https://smr76.github.io'>link</a>\n" +
                      "```\n" +
                      "let x = \n" +
                      "markdown\n" +
                      "```\n";
                Guide{}
            }
        }

        Column {
            width: 250; spacing: 5
        }
    }
}
