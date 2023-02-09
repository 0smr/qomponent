// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15 as QQ

QQ.Grid {
    id: control

    property int partition: 1
    readonly property real vertical: flow == QQ.Grid.TopToBottom
    readonly property real preferredItemSize: {
        const itemInRow = children.length/partition;
        return (vertical ? height : width)/itemInRow - spacing/itemInRow;
    }

    flow: QQ.Grid.TopToBottom
    columns: flow == QQ.Grid.TopToBottom ? partition : -1
    rows: flow == QQ.Grid.TopToBottom ? -1 : partition
    layoutDirection: Qt.LeftToRight
}
