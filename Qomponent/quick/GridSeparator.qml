// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15

Item {
    id: control

    property real length: 28
    property real fill: 0.7
    readonly property bool horizontal: (parent.flow ?? 0) === Grid.LeftToRight

    width: horizontal ? 0.00001 : length
    height: horizontal ? length : 0.0001
    z: 99

    Rectangle {
        x: horizontal == true  ? -0.25 : (parent.length - width)/2
        y: horizontal == false ? -0.25 : (parent.length - height)/2

        width: horizontal ? 0.5 : parent.length * parent.fill
        height: horizontal ? parent.length * parent.fill : 0.5

        color: palette.windowText
        opacity: 0.2
    }
}
