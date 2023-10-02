// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: control

    property var wordList: []
    property string delimiter: ' '

    padding: 0; topPadding: 1
    implicitWidth: Math.max(50, control.contentWidth + suggestion.width + 15)

    QtObject {
        id: priv

        property string lastWord: control.text.substr(control.text.lastIndexOf(delimiter) + 1)
        property string sentence: control.text.slice(0, control.text.lastIndexOf(delimiter) + 1)
        property string selected: control.wordList.reduce(wordReduce, {cd: Number.MAX_VALUE, str: ''}).str;

        function wordReduce({cd, str}, item) {
            const old = {cd, str}, diff = Math.abs(priv.lastWord.length - item.length);
            if(!cd || cd < diff || 5 < diff) return old;
            const dist = editdist(item, priv.lastWord);
            return dist < cd ? {cd:dist, str:item} : old;
        }

        /// FIXME: Move this function to c++ side
        /// Reference: https://gist.github.com/andrei-m/982927
        function editdist(a:string, b:string):int {
            if (!(a && b)) return (b || a).length;

            const m = Array(b.length + 1).fill().map((_,i) => Array(i).fill(i))
            m[0] = Array(a.length + 1).fill().map((_,i) => i)

            for (let i = 1; i <= b.length; i++) {
                for (let j = 1; j <= a.length; j++) {
                    const [_i,_j] = [i - 1, j - 1];
                    m[i][j] = b[_i] === a[_j] ? m[_i][_j] :
                                Math.min(m[_i][_j] + 2, m[i][_j] + 1, m[_i][j] + 1)
                }
            }

            return m[b.length][a.length];
        }
    }

    Keys.onTabPressed: {
        if(!text.endsWith(priv.selected)) {
            const newText = priv.sentence + priv.selected;
            control.clear();
            control.insert(0, newText);
            control.textEdited();
        }
    }

    background: Rectangle {
        implicitWidth: 50
        implicitHeight: 20

        color: Qomponent.alpha(palette.base, 0.3)
        border.color: palette.alternateBase
        border.width: 1
        opacity: 0.3 + 0.3 * control.focus
        radius: 3
        clip: true

        Text {
            id: suggestion
            x: control.leftPadding + control.contentWidth + 2

            height: parent.height
            width: implicitWidth * visible

            verticalAlignment: Qt.AlignVCenter
            visible: control.focus && !control.text.endsWith(priv.selected)

            text: priv.selected
            font: control.font
            color: control.color
        }
    }
}
