// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15 as QQ215

QQ215.Grid {
    id: control

    property int preferredRows: 1

    flow: QQ215.Grid.TopToBottom
    columns: flow == QQ215.Grid.TopToBottom ? preferredRows : -1
    rows: flow == QQ215.Grid.TopToBottom ? -1 : preferredRows
    layoutDirection: Qt.LeftToRight
}
