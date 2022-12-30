// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io
.pragma library

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

Array.prototype.qget = _qget;
Object.prototype.qget = _qget;
Number.prototype.qclamp = _qclamp;
