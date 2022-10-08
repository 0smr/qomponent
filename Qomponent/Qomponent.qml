// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

pragma Singleton

import QtQuick 2.15

Item {
    id: root

    function alpha(c, a) {
        return Qt.rgba(c.r,c.g,c.b,a);
    }

    function copy(text) {
        dummytedit.text = text;
        dummytedit.selectAll();
        dummytedit.copy();
    }

    TextEdit { id: dummytedit; visible: false; parent: null }
}
