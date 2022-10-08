// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Window 2.15

Item {
    id: control

    default property list<UITourItem> items
    readonly property alias index: window.index

    property alias window: window
    property alias text: text

    function start(index = 0) {
        if(index < items.length || window.index < items.length)
        window.showFullScreen();
        window.showNextMessage(index);
    }

    function skip() { window.showNextMessage(); }
    function skipAll() {
        window.index = Number.MAX_VALUE;
        window.close();
    }

    Window {
        id: window

        width: Screen.width
        height: Screen.height

        color: 'transparent'
        visibility: Window.Hidden
        flags: Qt.ToolTip |
               Qt.WA_DeleteOnClose |
               Qt.WindowStaysOnTopHint |
               Qt.WindowTransparentForInput

        /**
         * Array of {target: Item, text: "", align: Qt.AlignLeft}}
         */
        property int index: -1
        property int radius: (items[index] ?? {radius:25}).radius

        function showNextMessage(startIndex = undefined) {
            index = startIndex ?? index + 1;
            if(index < items.length) {
                const alignment = items[index].align;
                const message = items[index].text;
                const targetItem = items[index].target;
                const point = targetItem.mapToGlobal(targetItem.width/2 ,targetItem.height/2);

                focusIn(point);
                showMessage(message, point, alignment);
            } else {
                window.close();
            }
        }

        function showMessage(message, point, alignment) {
            text.text = message;
            const coord = alignTextTo(point, alignment);
            text.x = coord.x;
            text.y = coord.y;
            messageAnim.restart();
        }

        function alignTextTo(point, alignment) {
            point.x -= text.implicitWidth / 2;
            point.y -= text.implicitHeight / 2;

            const xshifter = window.radius + text.implicitWidth / 2 + 20;
            const yshifter = window.radius + text.implicitHeight / 2 + 20;

            switch(alignment) {
            case Qt.AlignLeft:
                return { x: point.x - xshifter, y: point.y };
            case Qt.AlignRight:
                return { x: point.x + xshifter, y: point.y };
            case Qt.AlignTop:
                return { x: point.x, y: point.y - yshifter };
            case Qt.AlignBottom:
                return { x: point.x, y: point.y + yshifter };
            default:
                return point;
            }
        }

        function focusIn(point) {
            shader.center = Qt.vector2d(point.x, point.y);
            focusAnim.restart();
        }

        Item { id: garbage }

        Connections {
            enabled: window.index < items.length
            target: (control.items[window.index] || {}).target || garbage
            ignoreUnknownSignals: true

            function onClicked() { window.showNextMessage(); }
        }

        ParallelAnimation {
            id: focusAnim
            NumberAnimation {
                target: shader; properties: 'radius'
                from: 200; to: window.radius; duration: 300
                easing.type: Easing.InSine
            }
            NumberAnimation {
                target: shader; properties: 'opacity'
                from: 0.1; to: 0.4 ; duration: 300
            }
        }

        NumberAnimation {
            id: messageAnim
            target: text; properties: 'opacity'
            from: 0; to: 0.8; duration: 600
        }

        ShaderEffect {
            id: shader
            opacity: 0.4
            anchors.fill: parent
            property real radius
            property vector2d center
            readonly property real _radius: radius/width
            readonly property real _smooth: 0.5/width
            readonly property vector2d _center: Qt.vector2d(center.x/width, center.y/width)
            readonly property vector2d _ratio: Qt.vector2d(width / Math.max(width, height),
                                                           height/ Math.max(width, height));
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                uniform highp vec2 _ratio;
                uniform highp vec2 _center;
                uniform highp float _radius;
                uniform highp float _smooth;

                void main() {
                    highp vec2 coord = _ratio * qt_TexCoord0;
                    highp float ring = smoothstep(0.0, _smooth, distance(coord, _center) - _radius);
                    gl_FragColor = vec4(0,0,0,1) * ring * qt_Opacity;
                }"
        }

        Text {
            id: text
            color: 'white'
            textFormat: Text.RichText
            font.bold: true
            font.pointSize: 11
        }
    }
}
