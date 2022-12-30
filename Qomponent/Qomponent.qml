// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

pragma Singleton

import QtQuick 2.15

Item {
    id: root

    /**
     * @method alpha
     * @param color input font
     * @param a new alpha value
     * @returns Input color with new alpha value.
     */
    function alpha(color: color, a: real): color {
        return Qt.rgba(color.r, color.g, color.b, a);
    }

    /**
     * @method font
     * @param ifont input font
     * @param properties new properties
     * @returns Input font with new properties.
     */
    function font(ifont: font, prop): font {
        return Qt.font(Object.assign({}, ifont, prop));
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
}
