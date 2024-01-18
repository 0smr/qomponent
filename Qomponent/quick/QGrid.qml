// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

Grid {
    id: control

    property int preferredRows: 1
    property bool vertical: false

    readonly property real avaliableWidth: width - 2 * spacing
    readonly property real avaliableHeight: height - 2 * spacing

    rows: vertical ? -1 : preferredRows
    columns: vertical ? preferredRows : -1
    flow: Grid.LeftToRight
    layoutDirection: Qt.LeftToRight
    horizontalItemAlignment: Grid.AlignHCenter
}
