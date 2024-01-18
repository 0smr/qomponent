// Copyright (C) 2023 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick

ShaderEffect {
    property var source
    property real bend: 0

    fragmentShader: "qrc:/qomponent/shader/elastic.frag.qsb"
}
