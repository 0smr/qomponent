// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

PropertyAnimation {
    id: control

    /**
     * @property {int} frame, Frames of animation from 0 to *duration/50* (this number is chosen by trial and error)
     *  Please keep in mind that the animation frame rate is always set to 30 FPS.
     */
    property int frame: 0
    /** @property {string} filter, Characters their animation will be skipped. */
    property string filter: "\n\t "
    property string _from: ""

    NumberAnimation on frame { id: anim
        from: 0; to: Math.floor(duration/50) // Remain at 30Fps
        duration: control.duration
        easing: control.easing
    }

    onStarted: {
        _from = from ?? target[this.property];
        anim.restart();
    }

    onFrameChanged: {
        if(property && target && typeof(_from) == "string" && typeof(to) == "string") {
            let text = "";
            const proc = frame / anim.to;
            for(let i = 0; i < to.length; ++i) {
                let res = to[i];
                if(![to[i], _from[i]].some(c => filter.includes(c))) {
                    const fc = _from.charCodeAt(i) || 48 + i % 50;
                    const tc = to.charCodeAt(i);
                    const diff = (tc - fc) * proc;
                    res = String.fromCharCode(Math.round(fc + diff));
                }
                text += res;
            }
            control.target[control.property] = text;
        }
    }
}
