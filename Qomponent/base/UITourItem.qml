import QtQuick

QtObject {
    id: control

    /** @property {Item} target, Target item. */
    required property Item target
    /** @property {string} text, Target text message. */
    property string text: ""
    /** @property {int} align, Target message prefered alignment. */
    property int align: Qt.AlignLeft
    /** @property {int} radius, focus circle radius. */
    property int radius: target.width ?? 25
}
