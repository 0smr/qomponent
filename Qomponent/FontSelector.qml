// Copyright (C) 2023 smr.
// SPDX-License-Identifier: MIT
// https://smr.best
//
// The FontSelector component is aimed at editing program fonts placed in a singleton global component.
// This component provides controls to change font properties,
//  such as family name, bold, italic, strikeout, underline, point size, and pixel size.
// note: style list can be modified.

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control

    /// @property {string} selected, Selected font property name.
    property string activeProperty: ''
    /// @property {*} properties, A model or array containing font property names.
    property alias properties: listview.model
    /// @property {QtObject} target, The target object contains font properties (i.e., a global singleton component for fonts).
    property QtObject target: this
    /// @property {*} styles, Array containing font style names.
    property var styles: ['bold','italic','underline','strikeout']

    property var fontFamilies: Qt.fontFamilies()

    /// @component PropLabel, Customized Label
    component PropLabel: Label {
        opacity: 0.5
        padding: 5
        topPadding: 0; bottomPadding: 0

        background: Rectangle {
            color: palette.text
            opacity: 0.3
            radius: 2
        }
    }


    contentItem: Column {
        spacing: 5
        ButtonGroup {
            id: buttonGroup
            onCheckedButtonChanged: control.activeProperty = checkedButton ? checkedButton.type : '';
        }

        /// @component FontEditor, A customized component to edit single font properties.
        FontEditor {
            id: fontEditor
            width: control.availableWidth
            visible: control.activeProperty

            styles: control.styles
            target: control.target
            property: control.activeProperty
            fontFamilies: control.fontFamilies

            onCloseClicked: buttonGroup.checkState = 0;
        }

        ListView {
            id: listview
            clip: true
            spacing: 3

            width: control.availableWidth
            height: control.availableHeight - fontEditor.visible * fontEditor.height - 5

            delegate: AbstractButton {
                id: fontdelegate

                property string type: modelData
                property font fontData: control.target[type] ?? font

                ButtonGroup.group: buttonGroup

                width: control.availableWidth
                padding: 5
                checkable: true

                onClicked: control.activeProperty = type

                contentItem: Flow {
                    spacing: 4

                    Label { /// Row indicator
                        text: '+'
                        rotation: fontdelegate.checked * -45
                        Behavior on rotation {NumberAnimation{duration: 100}}
                    }

                    Label { /// Target's property name
                        text: fontdelegate.type
                        font.capitalization: Font.Capitalize
                    }

                    PropLabel { /// Font family label
                        text: font.family
                        font.family: fontdelegate.fontData.family
                        font.bold: fontdelegate.fontData.bold
                        font.italic: fontdelegate.fontData.italic
                        font.underline: fontdelegate.fontData.underline
                        font.strikeout: fontdelegate.fontData.strikeout
                    }

                    PropLabel { /// Font size label
                        text: fontdelegate.fontData.pixelSize + ' px'
                    }

                    Repeater { /// Current font styles
                        model: control.styles.filter(k => fontdelegate.fontData[k])

                        PropLabel {
                            text: modelData[0].toUpperCase()
                            font: Qt.font({[modelData]:true})
                        }
                    }
                }

                background: Rectangle {
                    color: Qomponent.alpha(palette.base, fontdelegate.checked * 0.5)
                    border.color: palette.alternateBase
                    opacity: 0.5
                    radius: 2
                }
            }
        }
    }
}
