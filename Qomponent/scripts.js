// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io
.pragma library

/**
 * @abstract Same as array 'at' function.
 * @param {Number} index.
 * @returns Value at index.
 */
const _qat = function(index) {
    return this[index >= 0 ? index : this.length - index];
}

/**
 * @abstract
 *  Input properties are evaluated and the final value of current object is returned.
 * @param {String|Array<String>} properties properties chain as String or Array
 * @param {*} _default
 * @returns
 *  Return the final property in the properties chain, or default if the value is undefined.
 */
const _qget = function(properties, _default = undefined) {
    const keys = [] instanceof Array ? properties : properties.split(/[\[\]\.]/).filter(x => x);
    let result = this;
    for(const key of keys) {
        if(result[key] === undefined) return _default;
        else result = result[key];
    }
    return result;
}

/**
 * @abstract
 *  Clamp the Number value to min and max.
 * @param {Number} min
 * @param {Number} max
 * @returns Return a value between min and max.
 */
const _qclamp = function(min, max) {
    return Math.max(min, Math.min(this, max));
}

/**
 * @abstract
 *  Remove characters at given index.
 * @param {Number} index
 * @param {Number} count, number of characters should be removed.
 * @returns manipulated string.
 */
const _qsplice = function(index, count = 1, ...items) {
    return [this.substr(0, index), ...items, this.substr(Math.max(index, index + count))].join('');
}

Array.prototype.qat = _qat;
Array.prototype.qget = _qget;
Object.prototype.qget = _qget;
Number.prototype.qclamp = _qclamp;
String.prototype.qsplice = _qsplice;

/**
 * @method readableTime
 * @param {Number} milis, input time as mili second
 * @returns {Array} human readable time and poststring.
 */
function readableTime(milis) {
    const timestamps = [
        {txt:qsTr("month"),  ts: 2629746000}, // 30.436875 * 24 * 60 * 60 * 1000
        {txt:qsTr("week"),   ts: 604800000},
        {txt:qsTr("day"),    ts: 86400000},
        {txt:qsTr("hour"),   ts: 3600000},
        {txt:qsTr("minute"), ts: 60000},
        {txt:qsTr("second"), ts: 1000},
        {txt:qsTr("ms"),     ts: 1},
    ];
    const time = timestamps.find(ts => milis/ts.ts > 1) ?? timestamps.slice(-1)[0];
    return [Math.floor(milis/time.ts), time.txt];
}
