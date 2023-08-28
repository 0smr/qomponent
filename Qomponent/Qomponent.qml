// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

pragma Singleton

import QtQuick 2.15

Item {
    id: root

    property alias monofont: mplus1code

    /**
     * @method font
     * @param ifont input font
     * @param properties new properties
     * @returns Input font with new properties.
     */
    function font(ifont: font, properties): font {
        return Qt.font(Object.assign({}, ifont, properties));
    }

    /**
     * @method alpha
     * @param color input color
     * @param a new alpha value
     * @returns Input color with new alpha value.
     */
    function alpha(color: color, a: real): color {
        return Qt.rgba(color.r, color.g, color.b, a);
    }

    /**
     * @method qassign
     * @param object input font
     * @param value new properties
     * @returns dict font with new properties.
     */
    function qassign(object, value) {
        let temp = Object.assign({}, object, {})
        for(const key in value) {
            if(object.hasOwnProperty(key)) {
                temp[key] = value[key];
            }
        }
        return temp;
    }

    /**
     * @method copy
     * Copy input text to clipboard.
     * @param text
     */
    function copy(text) {
        dummytedit.text = text;
        dummytedit.selectAll();
        dummytedit.copy();
    }

    TextEdit { id: dummytedit; visible: false; parent: null }

    FontLoader {
        id: mplus1code
        source: 'qrc:/Qomponent/font/mplus1code.ttf'
    }
}
