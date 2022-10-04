// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

TextArea {
    id: control

    function markdownParser(markdownText) {
        markdownText = markdownText.replace(/^#{1}\s+?(.+?)$/gm, "<h1>$1</h1>"); // h1
        markdownText = markdownText.replace(/^#{2}\s+?(.+?)$/gm, "<h2>$1</h2>"); // h2
        markdownText = markdownText.replace(/^#{3}\s+?(.+?)$/gm, "<h3>$1</h3>"); // h3
        markdownText = markdownText.replace(/^#{4}\s+?(.+?)$/gm, "<h4>$1</h4>"); // h4
        markdownText = markdownText.replace(/^#{5}\s+?(.+?)$/gm, "<h5>$1</h5>"); // h5
        markdownText = markdownText.replace(/^#{6}\s+?(.+?)$/gm, "<h6>$1</h6>"); // h5
        markdownText = markdownText.replace(/\[(.*?)\]\((.+?)\)/g, "<a href='$2' target='_blank'>$1</a>"); // link
        markdownText = markdownText.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>"); // h5
        markdownText = markdownText.replace(/\*(.+?)\*/g, "<em>$1</em>"); // h5
        let lists = markdownText.match(/^(\s*([-\+\*]\s.+(\r?\n)?)+)$/gm);

        if(lists) {
            lists.forEach(list => {
                const htmlList = list.replace(/^\s*[-\+\*]\s(.+(\r?\n)?)$/gm, "<li>$1</li>");
                markdownText = markdownText.replace(list, "<ul>" + htmlList + "</ul>");
            });
        }

        markdownText = markdownText.replace(/(?<=[\w\s\.])(\r?\n)/g, "<br>"); // line break
        markdownText = markdownText.replace(/(\r?\n)/g, ""); // line break

        return markdownText.trim();
    }

    selectionColor: '#33000000'

    property string style: "h1,h2,h3,h4,h5,ul,li{margin:0px;padding:0px;}ul{list-style:lower-roman;}"
    property string markdown: ""

    text: '<style>' + style + '</style>'
          + markdownParser(markdown)

    padding: 7
    topPadding: 12

    readOnly: true
    selectByMouse: true

    wrapMode: Text.WordWrap
    textFormat: Text.RichText
    horizontalAlignment: Text.AlignJustify

    font: KnightPen.regularFont

    onLinkActivated: Qt.openUrlExternally(link)

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            copyButton.visible
            copyButton.x = mouse.x + 3
            copyButton.y = mouse.y + 3
        }
    }

    Button {
        id: copyButton
        text: 'copy'
        enabled: false
        visible: enabled
        onClicked: {
            enabled = false
        }
    }
}
