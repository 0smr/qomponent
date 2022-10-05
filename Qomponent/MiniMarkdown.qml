// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control
    property string css: "h1,h2,h3,h4,h5,ul,li{margin:0;padding:0}"+
                         "ul{list-style:lower-roman;}"+
                         `a{text-decoration:none;color:${palette.highlight}}` +
                         `code>a{text-decoration:none;color:${palette.text}}`;
    property string text: ""
    property alias textarea: textarea

    function markdownParser(markdown) {
        markdown = markdown.replace(/^#{1}\s+?(.+?)$/gm, "<h1>$1</h1>"); // 1# h1
        markdown = markdown.replace(/^#{2}\s+?(.+?)$/gm, "<h2>$1</h2>"); // 2# h2
        markdown = markdown.replace(/^#{3}\s+?(.+?)$/gm, "<h3>$1</h3>"); // 3# h3
        markdown = markdown.replace(/^#{4}\s+?(.+?)$/gm, "<h4>$1</h4>"); // 4# h4
        markdown = markdown.replace(/^#{5}\s+?(.+?)$/gm, "<h5>$1</h5>"); // 5# h5
        markdown = markdown.replace(/^#{6}\s+?(.+?)$/gm, "<h6>$1</h6>"); // 6# h6
        markdown = markdown.replace(/\[(.*?)\]\((.+?)\)/g, "<a href='$2' target='_blank'>$1</a>"); // [alt](url) link
        markdown = markdown.replace(/\*\*(.+?)\*\*/g, "<b>$1</b>"); // **text** bold
        markdown = markdown.replace(/\*(.+?)\*/g, "<i>$1</i>"); // *text* italic
        markdown = markdown.replace(/\```((\s|\S)+?)\```/g, "<code><a href='#code'><pre>$1</pre></a></code>"); // ```text``` code block
        markdown = markdown.replace(/\`(.+?)\`/g, "<code>$1</code>"); // `text` code
        markdown = markdown.replace(/_(.+?)_/g, "<i>$1</i>"); // _text_ emphasize
        let lists = markdown.match(/^(\s*([-\+\*]\s.+(\r?\n)?)+)$/gm);

        if(lists) {
            lists.forEach(list => {
                const htmlList = list.replace(/^\s*[-\+\*]\s(.+(\r?\n)?)$/gm, "<li>$1</li>");
                markdown = markdown.replace(list, "<ul>" + htmlList + "</ul>");
            });
        }
        markdown = markdown.replace(/(?<=[\w\s\.])(\r?\n)/g, "<br>"); // line break
//        markdown = markdown.replace(/(\r?\n)/g, ""); // line break
        return markdown.trim();
    }

    contentItem: TextArea {
        id: textarea

        text: '<style>' + control.css + '</style>' + markdownParser(control.text)

        selectionColor: Qomponent.alpha(palette.text, 0.1)
        selectedTextColor: palette.base

        padding: 7
        topPadding: 12

        readOnly: true
        selectByMouse: true

        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignJustify

        onLinkActivated: {
            if(link !== "#code") Qt.openUrlExternally(link)
            else {
                copyLabel.text = "Copied!"
                dummytextedit.text = link
            }
        }

        HoverHandler {
            id: hoverhandler
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }

        TextEdit { id: dummytextedit }
    }

    Label {
        id: copyLabel
        y: 5; x: parent.width - implicitWidth - 5
        padding: 5
        text: "Copy"
        font.pointSize: 7
        opacity: textarea.hoveredLink == '#code'
        background: Rectangle {
            radius: 2; opacity: 0.5
            border { width:1; color: palette.windowText }
            color: copyLabel.text == "Copy" ?
                       "transparent" : palette.windowText
        }

        Behavior on opacity { NumberAnimation{} }
        Timer {
            interval: 1300
            running: parent.text !== "Copy"
            onTriggered: parent.text = "Copy";
        }
    }
}
