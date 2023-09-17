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

    property alias bufferPalette: buffer.palette

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
        Object.keys(palette).forEach(k => target.palette[k] = buffer.palette[k]);
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
        property bool minimized: false
        property bool edited: false

        signal edited(text: string)
        signal resetClicked()
        signal expandClicked()

        checkable: true

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        contentItem: VRow {
            Row {
                Control {
                    width: parent.height; height: width
                    contentItem: Label {
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment:  Qt.AlignVCenter
                        rotation: colorItem.checked * 45
                        text: '+'
                        /// A gray scale color opposite to the background color.
                        color: Qt.hsla(0, 0, 1 - colorItem.color.hslLightness * 2, 0.5)

                        Behavior on rotation {NumberAnimation{ duration: 100 }}
                    }
                    background: Rectangle { radius: 2; color: colorItem.color }
                }

                /// Color label
                Label {
                    padding: 5
                    opacity: 0.5
                    text: colorItem.text
                    font.family: Qomponent.monofont.name
                }
            }

            Row {
                visible: !colorItem.minimized
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
                    text: 'reset'
                    visible: colorItem.edited
                    height: parent.height
                    width: implicitContentWidth

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
        id: buffer
        palette: control.target.palette
    }

    contentItem: Column {
        spacing: 5

        DragHandler { target: null }

        ButtonGroup {
            id: buttonGroup
            buttons: flow.children
            onCheckedButtonChanged: {
                control.selected = checkedButton ? checkedButton.modelData : ""
            }
        }

        ColorEditor {
            id: coloreditor

            clip: true
            padding: 2
            width: control.availableWidth
            visible: control.selected

            /// FIXME: Binding loop
            Binding on color {
                when: buffer.palette.hasOwnProperty(control.selected)
                value: buffer.palette[selected]
                restoreMode: Binding.RestoreNone
            }

            onColorChanged: {
                if(buffer.palette[selected] !== color && buffer.palette.hasOwnProperty(selected)) {
                    buffer.palette[selected] = color;
                }
            }

            ToolBtn {
                x: parent.availableWidth - width
                text: '+'
                contentItem.rotation: 45
                font.pixelSize: 15
                onClicked: buttonGroup.checkState = 0;
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
                        required property var modelData

                        text: modelData
                        clip: true
                        minimized: control.minibox
                        color: buffer.palette[modelData]
                        width: minimized ? implicitContentWidth: control.availableWidth
                        edited: buffer.palette[modelData] !== control.target.palette[modelData]

                        onEdited: val => buffer.palette[modelData] = val;
                        onResetClicked: if(control.validtarget) buffer.palette[modelData] = control.target.palette[modelData];
                    }
                }
            }
        }
    }
}
