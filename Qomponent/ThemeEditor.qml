// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr.best
//
// The ThemeEditor component lists the properties of the QML palette object
//  and provides a user-friendly panel for easily changing and editing palette colors.
// Currently, this component is designed for Qt5 controls and has not been tested for Qt6.

import QtQuick
import QtQuick.Controls.Basic
import QtQml

Control {
    id: control

    property alias bufferPalette: buffer.palette

    /// @property {*} target, contains the target item of ThemeEditor (default: parent)
    property var target: parent
    /// @property {string} property, target's palette property name (default: palette)
    property string property: 'palette'
    /// @property {string} selected, contains the name of the selected palette's property
    property string selected: ''
    /// @property {bool} minibox, minimizes the color list items (default: parent)
    property bool minibox: false
    /// @property {bool} validTarget, determines whether the target is valid or not.
    readonly property bool validtarget: target && target.hasOwnProperty(control.property)

    /// @abstract This function copy the temporary palette to the target palette.
    function save() {
        const keys = Object.keys(buffer.palette).filter(k => buffer.palette[k].hasOwnProperty('r'));
        keys.forEach(k => target[control.property][k] = buffer.palette[k]);
    }

    /// @abstract This function clear the selected palette string.
    function deselect() { selected = ''; }

    /// Update palette on target or property change
    onTargetChanged: buffer.palette = target[control.property]
    onPropertyChanged: buffer.palette = target[control.property]

    /// Custome tool button.
    component ToolBtn: ToolButton {
        padding: 0
        opacity: 0.5 + !down * 0.1
        font.pixelSize: 9
        font.family: Qomponent.monofont.name
        background: null
    }

    /// Color delegate component
    component ColorDelegate: AbstractButton {
        id: colorItem

        property color color: '#000'
        property bool minimized: false
        property bool modified: false

        signal edited(text: string)
        signal resetClicked()
        signal expandClicked()

        checkable: true

        HoverHandler { cursorShape: Qt.PointingHandCursor }

        contentItem: VRow {
            Row {
                padding: 1
                Control {
                    width: parent.height - 2; height: width
                    contentItem: Label {
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment:  Qt.AlignVCenter
                        rotation: colorItem.checked * 45
                        text: '+'
                        /// A gray scale color opposite to the background color.
                        color: ['#def','#123'][Math.round(colorItem.color.hslLightness + 0.2)]

                        Behavior on rotation {NumberAnimation{ duration: 100 }}
                    }

                    background: Rectangle {
                        color: colorItem.color
                        radius: 2
                    }
                }

                /// Color label
                Label {
                    padding: 3
                    opacity: 0.5
                    text: colorItem.text
                    font.family: Qomponent.monofont.name
                }
            }

            Row {
                visible: !colorItem.minimized
                rightPadding: 6

                TextField {
                    padding: 5

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
                    visible: colorItem.modified
                    height: parent.height
                    width: implicitContentWidth

                    onClicked: colorItem.resetClicked()
                }
            }
        }

        background: Rectangle {
            color: Qomponent.alpha(palette.base, colorItem.checked * 0.5)
            border.color: palette.alternateBase
            opacity: 0.5
            radius: 2
        }
    }

    Control {
        id: buffer
        palette: control.target[control.property]
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
                spacing: 3
                width: control.availableWidth

                Repeater {
                    model: Object.keys(buffer.palette).filter(k => buffer.palette[k].hasOwnProperty('r'))

                    delegate: ColorDelegate {
                        required property var modelData

                        text: modelData
                        clip: true
                        minimized: control.minibox
                        color: buffer.palette[modelData]
                        width: minimized ? implicitContentWidth: control.availableWidth
                        modified: control.validtarget && buffer.palette[modelData] !== control.target[control.property][modelData]

                        onEdited: val => buffer.palette[modelData] = val;
                        onResetClicked: if(control.validtarget) buffer.palette[modelData] = control.target[control.property][modelData];
                    }
                }
            }
        }
    }
}
