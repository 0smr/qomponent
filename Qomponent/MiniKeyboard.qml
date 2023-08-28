// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

Control {
    id: control

    padding: 5
    visible: false
    parent: Window.window.contentItem

    QtObject {
        id: internals

        /** @property {int} imh, The animation of characters will be skipped. */
        readonly property int imh: (target ?? {}).inputMethodHints ?? 0
        /** @property {bool} digitOnly, True if the target only takes digits. */
        readonly property bool digitOnly: digit && !alphabet
        /** @property {bool} emailOnly, True if the target only accepts email characters. */
        readonly property bool emailOnly: imh & Qt.ImhEmailCharactersOnly
        /** @property {bool} switchCase,True if the target has the ability to switch cases. */
        readonly property bool switchCase: {
            !(imh & (Qt.ImhUppercaseOnly | Qt.ImhLowercaseOnly)) && !digitOnly
        }

        function imhUppercase(ihints: int) {
            return ihints & (Qt.ImhUppercaseOnly | Qt.ImhPreferUppercase) &&
                 !(ihints & (Qt.ImhLowercaseOnly | Qt.ImhPreferLowercase));
        }

        function imhLatin(ihints: int) {
            return [Qt.ImhLatinOnly].includes(ihints) ||
                  ![Qt.ImhDigitsOnly, Qt.ImhFormattedNumbersOnly].includes(ihints);
        }

        function imhDigits(ihints: int) {
            return [Qt.ImhDigitsOnly, Qt.ImhFormattedNumbersOnly].includes(ihints) ||
                  ![Qt.ImhLatinOnly].includes(ihints);
        }
    }

    /** @signal clicked, When a user clicks a button, this event is triggered. */
    signal clicked(Item button, string text)
    /** @signal pressed, When the user presses a button, the event is triggered. */
    signal pressed(Item button, string text)
    /** @signal released, When a user releases a pushed button, this event is triggered. */
    signal released(Item button, string text)

    /** @property {real} margin, Minimum gap between the window and the text field. */
    property real margin: 3

    /** @property {bool} uppercase, Indicates whether the letters are uppercase or lowercase. */
    property bool uppercase
    /** @property {bool} alphabet, Indicates whether or not the alphabet button is displayed. */
    property bool alphabet: true
    /** @property {bool} digit, Indicates whether or not the digit buttons are enabled. */
    property bool digit: true

    /** @property {var} charMap, This property maps characters to those that must be displayed for button text. */
    property var charMap: {" ": "\u02fd", "backspace": "\u2190", "capslock": "\u2191"}
    /** @property {var} keyMap, This property associates characters with the function they should do when clicked or pushed. */
    property var keyMap: {
        "backspace": () => {
            // TODO: Characters should be removed before the text cursor position.
            const str = target.text;
            const ss = Math.max(0, target.selectionStart ?? target.length) - 1;
            target.text = ss >= 0 ? str.qsplice(ss, 1) : str;
            target.select(ss, ss);
            return "";
        },
        "capslock": () => {
            uppercase ^= 1;
            return "";
        }
    }
    /** @property {Item} target, It contains the target text input. If the target is not a text input, it returns null. */
    property Item target: {
        const input = Window.activeFocusItem;
        return typeFilter(input) ? input : null;
    }
    /** @property {Function} typeFilter, Filter target types with this function. */
    property var typeFilter: function(item) {
        const type = item instanceof TextField || item instanceof TextArea ||
                     item instanceof TextEdit || item instanceof TextInput;
        return item && type && item.enabled && item.readOnly === false;
    }
    /** @property {Component} delegate, Keyboard button delegate. */
    property Component delegate: RoundButton {
        implicitWidth: 20; implicitHeight: implicitWidth
        radius: 2
        text: control.charMap[modelData] ?? modelData
        font: control.font
        focusPolicy: Qt.NoFocus
        width: control.alphabet && modelData === ' ' ? 3 * implicitWidth : implicitWidth
        autoRepeat: true
        onClicked:  control.clicked(this,  modelData);
        onPressed:  control.pressed(this,  modelData);
        onReleased: control.released(this, modelData);
    }

    component KeyGroup: Grid {
        property Component delegate: control.delegate
        property var model
        columns: -1; rows: 1
        spacing: parent.spacing
        Repeater { model: parent.model; delegate: parent.delegate }
    }

    onTargetChanged: {
        visible = false;
        const _target = target;

        if(_target) {
            const ihints = target.inputMethodHints
            uppercase = internals.imhUppercase(ihints);
            alphabet = internals.imhLatin(ihints);
            digit = internals.imhDigits(ihints);

            Qt.callLater(() => {
                 const window = Window.window;
                 const pos = _target.mapToItem(window.contentItem ?? {}, 0, 0);
                 x = pos.x.qclamp(margin, window.width - width - 2 * margin);
                 y =  pos.y > height ?  pos.y - height - margin :  pos.y + _target.height;
                 /// NOTE: Sometimes callLater runs after the target changes.
                 visible = target;
            })
        }
    }

    onPressed: {
        if(target) {
            const len = target.text.lenght;
            const val = keyMap[text] instanceof(Function) ? keyMap[text]() : text;
            const ss = Math.max(0, target.selectionStart ?? target.length);
            target.text = target.text.qsplice(ss, 0, val);
            val && target.select(ss + 1, ss + 1);
            // TODO: Characters should be inserted after the text cursor position.
        }
    }

    background: Rectangle {
        color: Qomponent.alpha(palette.windowText, 0.4)
        border { width: 1; color: palette.windowText }
        radius: 3
        opacity: 0.5
    }

    contentItem: Grid {
        id: grid
        spacing: 1; columns: 1
        horizontalItemAlignment: Grid.AlignHCenter
        KeyGroup {
            visible: digit
            columns: internals.digitOnly ? 3 : -1
            rows: internals.digitOnly ? -1 : 1
            flow: Grid.LeftToRight
            /// If it's digitOnly, exclude zero.
            model: alphabet && uppercase ? "!@#$%^&*()".split("") :
                                           "1234567890".substr(0, 10 - internals.digitOnly).split("")
        }
        KeyGroup { visible: alphabet; model: (uppercase ? "QWERTYUIOP" : "qwertyuiop").split("") }
        KeyGroup { visible: alphabet; model: (uppercase ? "ASDFGHJKL" : "asdfghjkl").split("") }
        KeyGroup { visible: alphabet; model: (uppercase ? "ZXCVBNM" : "zxcvbnm").split("") }
        KeyGroup {
            columns: internals.digitOnly ? 3 : -1
            rows: internals.digitOnly ? -1 : 1
            model: {
                /**
                 * include capslock button, If switchCase is enabled.
                 * include zero button, If digitOnly is enabled.
                 */
                return [internals.switchCase && 'capslock', !internals.digitOnly && ' ',
                        '.', internals.digitOnly && '0', 'backspace'].filter(i => i)
            }
        }
    }
}
