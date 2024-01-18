import QtQuick
import QtQuick.Controls.Basic

ApplicationWindow {
    id: window
    width: 280
    height: 460
    visible: true

    contentData: Page2 {
        width: window.width
        height: window.height
    }
}
