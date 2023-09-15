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
    property string selected: ''
    /// @property {*} properties, A model or array containing font property names.
    property alias properties: listview.model
    /// @property {QtObject} target, The target object contains font properties (i.e., a global singleton component for fonts).
    property QtObject target: this
    /// @property {*} styles, Array containing font style names.
    property var styles: ['bold','italic','underline','strikeout']

    property var systemFontFamilies: Qt.fontFamilies()

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

    /// @component ToolBtn, Customized ToolButton
    component ToolBtn: ToolButton {
        padding: 5
        topPadding: 3; bottomPadding: 3
        opacity: 0.8 + 0.2 * !down

        background: Rectangle {
            border.color: control.palette.text
            color: Qomponent.alpha(border.color, parent.checked)
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
            color: control.palette.text
            origin: color
            offset: width/2
        }
    }

    /// @component FontEditor, A customized component to edit single font properties.
    component FontEditor: Control {
        id: editor

        /// @property {*} selected, Selected font property
        property var selected: control.target[control.selected] ?? font

        padding: 5
        clip: true

        contentItem: Column {
            spacing: 3

            VRow {
                width: parent.width

                Label {
                    padding: 3
                    opacity: 0.5
                    text: control.selected
                }

                AutoCompleteInput {
                    text: editor.selected.family ?? ''
                    wordList: control.systemFontFamilies
                    delimiter: ','
                    selectByMouse: true
                    onTextEdited: editor.selected.family = text
                }

                ToolBtn {
                    text: '+'
                    padding: 3
                    contentItem.rotation: 45
                    onClicked: {
                        /// Uncheck selected button
                        buttonGroup.checkedButton.checked = false;
                        control.selected = '';
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
                        checked: editor.selected[prop]
                        onCheckedChanged: editor.selected[prop] = checked
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
                }

                SizeSlider {
                    id: slider
                    property var props: ['pixelSize','pointSize']
                    width: editor.availableWidth - 80
                    from: 3; to: 28
                    value: editor.selected[props[unit.idx]]
                    onMoved: {
                        editor.selected[props[1 - unit.idx]] = 0;
                        editor.selected[props[unit.idx]] = value
                    }
                }
            }

            Row {
                spacing: 3
                Label { text: 'sample:'; opacity: 0.5 }

                TextInput { /// Test Text Input
                    text: '123abcABC-,'
                    color: palette.text
                    font: editor.selected
                    selectionColor: control.palette.highlight
                    selectedTextColor: control.palette.highlightedText
                }
            }
        }

        background: Rectangle {
            border.color: palette.text
            color: palette.base
            opacity: 0.3
            radius: 2
        }
    }

    contentItem: Column {
        spacing: 5

        FontEditor {
            id: fontEditor
            visible: control.selected
            width: control.availableWidth
        }

        ButtonGroup {
            id: buttonGroup
        }

        ListView {
            id: listview
            clip: true
            spacing: 2

            width: control.availableWidth
            height: control.availableHeight - fontEditor.height - 5

            delegate: AbstractButton {
                id: fontdelegate

                property string type: modelData
                property font fontData: control.target[type] ?? font

                ButtonGroup.group: buttonGroup

                width: control.availableWidth
                padding: 5
                checkable: true
                autoExclusive: true

                onClicked: control.selected = type

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
                    color: Qomponent.alpha(palette.text, fontdelegate.checked * 0.5)
                    border.color: palette.text
                    opacity: 0.3
                    radius: 2
                }
            }
        }
    }
}
