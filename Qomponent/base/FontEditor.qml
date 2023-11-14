// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

Control {
    id: control

    padding: 5
    clip: true

    /// @property {*} selected, Selected font property
    property var target
    property string property: 'font'
    property var styles: ['bold','italic','underline','strikeout']
    property var fontFamilies: []

    readonly property var activeFont: target[control.property] ?? font

    signal closeClicked()

    /// @component ToolBtn, Customized ToolButton
    component ToolBtn: ToolButton {
        padding: 5
        topPadding: 3; bottomPadding: 3
        opacity: 0.8 + 0.2 * !down

        background: Rectangle {
            border.color: palette.alternateBase
            color: Qomponent.alpha(palette.base, parent.checked)
            opacity: 0.3
            radius: 2
        }
    }

    /// @component TabBtn, Customized TabButton
    component TabBtn: TabButton {
        padding: 1
        width: implicitWidth
        opacity: 0.5 + checked * 0.5
        background: null
    }

    /// @component SizeSlider, Customized Slider
    component SizeSlider: Slider {
        padding: 1; width: 50; height: 10
        stepSize: 1.0

        handle: Rectangle {
            x: parent.visualPosition * parent.availableWidth
            width: 1; height: 10
            color: '#f03b33'
        }

        background: Ruler {
            property real sec: width/(parent.to - parent.from + thickness - 0.1)

            thickness: 0.5
            step: Qt.vector4d(2,sec/4,sec/2, sec)
            size: Qt.vector4d(0,0.2,0.4,0.6)
            color: parent.palette.text
            origin: color
            offset: width/2
        }
    }

    contentItem: Column {
        spacing: 3

        VRow {
            width: parent.width

            Label {
                padding: 3
                opacity: 0.5
                text: control.property
            }

            AutoCompleteInput {
                text: control.activeFont.family ?? ''
                wordList: control.fontFamilies
                delimiter: ','
                selectByMouse: true
                onTextEdited: control.activeFont.family = text
            }

            ToolBtn {
                text: '+'
                padding: 3
                contentItem.rotation: 45
                onClicked: {
                    /// Uncheck selected button
                    control.closeClicked()
                }
            }
        }

        Row {
            spacing: 3
            Repeater {
                model: control.styles

                ToolBtn {
                    property string prop: modelData

                    text: prop[0].toUpperCase()
                    font: Qt.font({[prop]:true})
                    checkable: true
                    checked: control.activeFont[prop]
                    onCheckedChanged: control.activeFont[prop] = checked
                }
            }
        }

        VRow {
            width: parent.width
            Label {
                id: sizeLabel
                font: Qomponent.monofont.name
                text: slider.value.toFixed(unit.idx).padEnd(4)
            }

            TabBar {
                id: unit
                property alias idx: unit.currentIndex
                TabBtn { text: 'px' }
                TabBtn { text: 'pt' }
                background: null
            }

            SizeSlider {
                id: slider
                property var props: ['pixelSize','pointSize']
                width: control.availableWidth - 80
                from: 3; to: 28
                value: control.activeFont[props[unit.idx]]
                onMoved: {
                    /// Create a clone font with filtered properties
                    var newFont = Qt.font(Qomponent.qfilter(control.activeFont, props));
                    /// Assgin new property
                    newFont[props[unit.idx]] = value;
                    /// Assign new font to taget
                    control.target[control.property] = newFont;
                }
            }
        }

        Row {
            spacing: 3
            Label { text: 'sample:'; opacity: 0.5 }

            TextInput { /// Test Text Input
                text: '123abcABC-,'
                color: palette.text
                font: control.activeFont
                selectionColor: palette.highlight
                selectedTextColor: palette.highlightedText
            }
        }
    }

    background: Rectangle {
        color: Qomponent.alpha(palette.base, 0.3)
        border.color: palette.alternateBase
        opacity: 0.5
        radius: 2
    }
}
