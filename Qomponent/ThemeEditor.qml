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
    component CustomToolButton: ToolButton {
        padding: 0
        background: null
        opacity: down ? 0.6 : 0.7
        font.pointSize: 7
        font.family: Qomponent.monofont.name
    }

    /// Color delegate component
    component ColorDelegate: Control {
        id: colorItem

        property color color: '#000'
        property size box: Qt.size(25, 25)
        property bool minibox: false

        signal edited(text: string)
        signal resetClicked()
        signal expandClicked()

        contentItem: Grid {
            CustomToolButton {
                id: expandbtn
                width: colorItem.box.width
                height: colorItem.box.height

                text: '+'
                opacity: down ? 0.8 : 1
                /// A gray scale color opposite to the background color.
                palette.buttonText: Qt.hsla(0, 0, 1 - colorItem.color.hslLightness * 2, 0.5)

                background: Rectangle {
                    color: colorItem.color
                    radius: 2
                }

                onClicked: colorItem.expandClicked();
            }

            /// Color label
            Label {
                padding: 5
                /// Fills all remaining space of parent row.
                width: colorItem.minibox ? implicitWidth : parent.width - (txtedit.width + resetbtn.width + expandbtn.width)
                color: palette.text
                text: modelData
                opacity: 0.5
                clip: true
            }

            TextInput {
                id: txtedit
                padding: 5; rightPadding: 0;

                /// Validate if color pattern is correct.
                /// The pattern should start with # following 3 or 6 hex digits.
                validator: RegularExpressionValidator {
                    regularExpression: /#([\da-f]{3}){1,2}/i
                }

                visible: !colorItem.minibox
                text: colorItem.color
                color: palette.text
                font.family: Qomponent.monofont.name
                font.pointSize: 7.5
                selectionColor: '#515253'
                selectByMouse: true

                onTextEdited: acceptableInput && colorItem.edited(text);

                /// This is a hover handler that only changes the cursor shape on hover.
                HoverHandler { cursorShape: Qt.IBeamCursor }
            }

            CustomToolButton {
                id: resetbtn
                visible: !colorItem.minibox
                width: colorItem.box.width + 10
                height: colorItem.box.height
                text: 'reset'

                onClicked: colorItem.resetClicked()
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

            CustomToolButton {
                x: parent.width - width - 5
                padding: 0; width: 5; text: 'x'
                font.pointSize: 9
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
                        onExpandClicked: control.selected = modelData;
                    }
                }
            }
        }
    }
}
