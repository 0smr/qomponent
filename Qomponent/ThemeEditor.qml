// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr.best
//
// The ThemeEditor component lists the properties of the QML palette object
//  and provides a user-friendly panel for easily changing and editing palette colors.
// Currently, this component is designed for Qt5 controls and has not been tested for Qt6.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQml 2.15

Control {
    id: control

    property alias tempPalette: temp.palette

    /// @property {*} target, contains the target item of ThemeEditor (default: parent)
    property var target: parent
    /// @property {string} selected, contains the name of the selected palette's property
    property string selected: ''
    /// @property {bool} minibox, minimizes the color list items (default: parent)
    property bool minibox: false
    /// @property {bool} validTarget, determines whether the target is valid or not.
    readonly property bool validtarget: target && target.hasOwnProperty('palette')

    /// @abstract This function copy the temporary palette to the target palette.
    function save() {
        Object.keys(palette).forEach(k => target.palette[k] = temp.palette[k]);
    }

    /// @abstract This function clear the selected palette string.
    function deselect() { selected = ''; }

    /// Custome tool button.
    component ToolBtn: ToolButton {
        padding: 0
        opacity: 0.5 + !down * 0.1
        font.pixelSize: 10
        font.family: Qomponent.monofont.name
        background: null
    }

    /// Color delegate component
    component ColorDelegate: AbstractButton {
        id: colorItem

        property color color: '#000'
        property size box: Qt.size(25, 25)
        property bool minibox: false

        signal edited(text: string)
        signal resetClicked()
        signal expandClicked()

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        contentItem: VRow {
            Row {
                Label {
                    id: expandbtn
                    width: parent.height; height: width
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment:  Qt.AlignVCenter

                    text: '+'
                    /// A gray scale color opposite to the background color.
                    color: Qt.hsla(0, 0, 1 - colorItem.color.hslLightness * 2, 0.5)
                    background: Rectangle { radius: 2; color: colorItem.color }
                }

                /// Color label
                Label {
                    padding: 5
                    opacity: 0.5
                    text: modelData
                    font.family: Qomponent.monofont.name
                }
            }

            Row {
                visible: !colorItem.minibox
                rightPadding: 6

                TextField {
                    padding: 6

                    /// Validate if color pattern is correct.
                    /// The pattern should start with # following 3 or 6 hex digits.
                    validator: RegularExpressionValidator {
                        regularExpression: /#([\da-f]{3}){1,2}/i
                    }

                    text: colorItem.color
                    font.family: Qomponent.monofont.name
                    font.pixelSize: 10
                    selectByMouse: true

                    onTextEdited: acceptableInput && colorItem.edited(text);
                    background: null
                }

                ToolBtn {
                    height: parent.height; width: implicitContentWidth
                    text: 'reset'

                    onClicked: colorItem.resetClicked()
                }
            }
        }

        background: Rectangle {
            color: palette.windowText
            opacity: 0.1
            radius: 2
        }
    }

    Control {
        id: temp
        palette: control.target.palette
    }

    contentItem: Column {
        spacing: 5

        ColorEditor {
            id: coloreditor

            clip: true
            padding: 2
            width: control.availableWidth
            visible: control.selected

            /// FIXME: Binding loop
            Binding on color {
                when: temp.palette.hasOwnProperty(control.selected)
                value: temp.palette[selected]
                restoreMode: Binding.RestoreNone
            }

            onColorChanged: {
                if(temp.palette[selected] !== color && temp.palette.hasOwnProperty(selected)) {
                    temp.palette[selected] = color;
                }
            }

            ToolBtn {
                x: parent.availableWidth - width
                text: '+'
                contentItem.rotation: 45
                font.pixelSize: 15
                onClicked: control.selected = '';
            }
        }

        Flickable {
            contentWidth: flow.width
            contentHeight: flow.height

            height: control.availableHeight - (coloreditor.height * coloreditor.visible) - 5
            width: control.availableWidth

            clip: true

            Flow {
                id: flow
                spacing: 5
                width: control.availableWidth

                Repeater {
                    model: Object.keys(palette)

                    delegate: ColorDelegate {
                        clip: true
                        minibox: control.minibox
                        color: temp.palette[modelData]
                        width: minibox ? implicitContentWidth: control.availableWidth

                        onEdited: val => temp.palette[modelData] = val;
                        onResetClicked: if(control.validtarget) temp.palette[modelData] = control.target.palette[modelData];
                        onClicked: control.selected = modelData;
                    }
                }
            }
        }
    }
}
