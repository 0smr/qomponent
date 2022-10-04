// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

PropertyAnimation {
    id: control

    property Item target
    property int num

    NumberAnimation on num { id: anim
        from: 0; to: duration/33 // Remain at 30Hz
        duration: control.duration
    }

    onNumChanged: {
        const _from = from ?? target[property];
        if(property && target && typeof(_from) == "string" && typeof(to) == "string") {
            let text = "";
            const proc = num / anim.to;
            for(let i = 0; i < to.length; ++i) {
                const fc = _from.charCodeAt(i) || 48 + i % 50;
                const tc = to.charCodeAt(i);
                const diff = (tc - fc) * proc;
                const res = String.fromCharCode((fc + diff).toFixed());
                text += res;
            }
            control.target[control.property] = text
        }
    }

    onRunningChanged: {
        anim.restart();
    }
}
