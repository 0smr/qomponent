import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Control {
    id: control

    visible: false

    /**
     * FIXME: There should be a frame change on the source before starting the animation,
     *  to allow ShaderEffectSource to capture the latest state.
     */
    property alias center: scene.point
    property alias radius: scene.radius
    property alias source: shaderSource.sourceItem
    property alias duration: animation.duration
    property alias running: animation.running

    function capture(callback, delay = 16) {
        control.visible = true
        shaderSource.scheduleUpdate();
        delayedCall.interval = delay;
        delayedCall.callback = callback;
        delayedCall.restart();
    }

    Timer {
        id: delayedCall
        property var callback;
        onTriggered: {
            callback && callback();
            animation.restart();
        }
    }

    ShaderEffectSource {
        id: shaderSource
        sourceItem: content
        visible: false
        live: false
    }

    contentItem: ShaderEffect {
        id: scene
        width: control.width; height: control.height

        property var source: shaderSource
        property real spread: 1
        property real radius
        property point point

        readonly property size _size: Qt.size(width, height)
        readonly property real _ssv: spread * 50/Math.min(width, height)

        NumberAnimation on radius {
            id: animation
            from: 0; to: Math.max(width, height) * 1.41
            running: false
            duration: 500
            onFinished: control.visible = false;
        }

        fragmentShader: "
            uniform sampler2D source;
            varying highp vec2 qt_TexCoord0;
            uniform highp float qt_Opacity;
            uniform highp float radius;
            uniform highp float _ssv;
            uniform highp vec2 _size;
            uniform highp vec2 point;
            void main() {
                vec2 uv = qt_TexCoord0 * _size - point;
                gl_FragColor = texture2D(source, qt_TexCoord0) * smoothstep(.0, _ssv, length(uv) - radius) * qt_Opacity;
            }"
    }
}
