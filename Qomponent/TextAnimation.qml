// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

PropertyAnimation {
    id: control

    property int num
    property string _from
    property string filter: "\n\t "

    NumberAnimation on num { id: anim
        from: 0; to: Math.floor(duration/50) // Remain at 30Hz
        duration: control.duration
        easing: control.easing
    }

    onStarted: {
        _from = from ?? target[property];
        anim.restart();
    }

    onNumChanged: {
        if(property && target && typeof(_from) == "string" && typeof(to) == "string") {
            let text = "";
            const proc = num / anim.to;
            for(let i = 0; i < to.length; ++i) {
                let res = to[i];
                if(![to[i],_from[i]].some(c => filter.includes(c))) {
                    const fc = _from.charCodeAt(i) || 48 + i % 50;
                    const tc = to.charCodeAt(i);
                    const diff = (tc - fc) * proc;
                    res = String.fromCharCode(Math.round(fc + diff));
                }
                text += res;
            }
            control.target[control.property] = text
        }
    }
}
