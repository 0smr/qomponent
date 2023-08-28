// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15

Row {
    property real minSpacing: 0
    readonly property real childrenWidth: ((...a) => a).apply(null, children).reduce((a, e) => a + e.width, 0)
    spacing: Math.max((width - childrenWidth - padding * 2)/(children.length-1), minSpacing, 0);
}
