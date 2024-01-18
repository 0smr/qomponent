// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

Control {
    id: control

    property int size: 1000

    padding: 1
    implicitWidth: 200
    implicitHeight: 100

    property ListModel model: ListModel {
        onRowsInserted: function(_, index) {
            if(canvas.imageData) {
                const value = model.get(index).value;
                canvas.imageData.data[4 * (index).qclamp(0, size) + 3] = value * 255;
            }
        }

        /// TODO: Add ability to update & move data.
        onRowsMoved: function(_, index) {}

        /// TODO: Add ability to remove data.
        onRowsRemoved: function(_, index) {}
    }

    contentItem: ShaderEffect {
        id: shader

        // Chart color
        property color color: palette.button
        // Chart data and shader source
        property Canvas source: Canvas {
            id: canvas
            width: Math.max(1, model.count - 1); height: 1

            property var imageData: undefined
            function updateImageData() {
                const ctx = getContext('2d');
                imageData = ctx && ctx.createImageData(size, height);
            }

            Connections {
                target: control
                function onSizeChanged() { if(available) updateImageData(); }
            }

            onAvailableChanged: if(available) updateImageData();
            onPaint: {
                if(imageData) {
                    const ctx = getContext('2d');
                    ctx.clearRect(0, 0, width, height);
                    model.count && ctx.drawImage(imageData, 0, 0);
                }
            }
        }

        fragmentShader: "qrc:/qomponent/shader/bar-chart.frag.qsb"
    }

    background: Rectangle {
        color: 'transparent'
        border.color: '#fff'
        opacity: 0.2; radius: 2
    }
}
