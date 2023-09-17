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
    function font(ifont: font, properties: Object): font {
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
     * @abstract This function create a clone of input object and override with new values.
     * @method qassign
     * @param {Object} object, input object
     * @param {Object} value, new verride values
     * @returns cloned object with new properties.
     */
    function qassign(object: Object, values: Object): Object {
        const obj = Object.assign({}, object, {})
        Object.keys(values)
            .filter(k => object.hasOwnProperty(k))
            .forEach(k => obj[k] = value[k]);
        return obj;
    }

    /**
     * @param {Object} object, input object.
     * @param {Array} value, filter property keys.
     * @returns {Object} cloned object with filtred properties.
     */
    function qfilter(object: Object, filter: Array): Object {
        const obj = {};
        Object.keys(object)
            .filter(k => !filter.includes(k))
            .forEach(k => obj[k] = object[k]);
        return obj;
    }

    /**
     * @method copy
     * Copy input text to clipboard.
     * @param {String} text
     */
    function copy(text: string) {
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
