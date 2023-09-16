// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

Control {
    id: control

    property alias color: colorpicker.color

    component NumberInput: TextInput {
        property var target: null
        property string prop: ''
        readonly property bool valid: target && target.hasOwnProperty(prop)

        font.family: Qomponent.monofont.name
        font.pixelSize: 10
        color: palette.text
        validator: DoubleValidator { bottom: 0; top: 1; decimals: 2 }
        text: (target && Number(target[prop]).toFixed(2)) ?? '0.00'
        selectByMouse: true
        selectionColor: '#99999999'

        onTextEdited: if(valid && text) target[prop] = text;

        DragHandler {
            property real init

            target: null
            margin: active * 50
            dragThreshold: 1
            yAxis.enabled: false
            cursorShape: Qt.SizeHorCursor
            /// To prevent other items from stealing the drag event.
            grabPermissions: PointerHandler.CanTakeOverFromAnything

            onActiveChanged: {
                if(active) init = Number(parent.text);
                parent.cursorVisible = !active;
            }
            onTranslationChanged: {
                if(active && parent.valid) {
                    parent.target[parent.prop] = (init + translation.x/50).qclamp(0,1);
                }
            }
        }
    }

    background: Rectangle {
        color: 'transparent'
        border.color: '#fff'
        opacity: 0.5
        radius: 2
    }

    contentItem: Row {
        spacing: 5
        ColorPicker {
            id: colorpicker

            width: 70 + spectrumWidth
            height: 70
            spectrumWidth: focus ? 8 : 5
            Behavior on spectrumWidth { NumberAnimation {} }
        }

        Column {
            spacing: 6

            Repeater {
                model: [
                    {label: 'hsva', p:['hsvHue', 'hsvSaturation', 'hsvValue', 'a']},
                    {label: 'hsla', p:['hslHue', 'hslSaturation', 'hslLightness', 'a']},
                    {label: 'rbga', p:'rbga'.split('')},
                ]

                Row {
                    Label {
                        text: modelData.label + ': '
                        font.family: Qomponent.monofont.name
                        font.pixelSize: 10
                    }

                    Repeater {
                        model: modelData.p

                        NumberInput {
                            target: colorpicker.color
                            prop: modelData
                            rightPadding: 5

                            Rectangle {
                                y: parent.height - 1
                                width: parent.width - 5; height: 0.5
                                opacity: 0.5
                            }
                        }
                    }
                }
            }

            Label {
                font.family: Qomponent.monofont.name
                text: 'hex:  ' + colorpicker.color
            }
        }
    }
}
