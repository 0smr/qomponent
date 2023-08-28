// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15 as QQ215

QQ215.Grid {
    id: control

    property int preferredRows: 1
    property bool vertical: false

    rows: vertical ? -1 : preferredRows
    columns: vertical ? preferredRows : -1
    flow: QQ215.Grid.LeftToRight
    layoutDirection: Qt.LeftToRight
    horizontalItemAlignment: QQ215.Grid.AlignHCenter
}
