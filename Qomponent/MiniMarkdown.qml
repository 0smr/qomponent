// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

Control {
    id: control
    property string css: "h1,h2,h3,h4,h5,ul,li{margin:0;padding:0}"+
                         "ul{list-style:lower-roman;}"+
                         `a{color:${palette.highlight}}` +
                         `a:hover{color:red}` +
                         `code>a{text-decoration:none;color:${palette.text}}`;
    property string text: ""
    property alias textarea: textarea
    property bool trimStart: false

    QtObject {
        id: internals

        function trimStart(str) {
            if(control.trimStart) {
                // Find minimum white spaces each line have.
                const minlen = str.match(/^[\t ]*\S/gm).reduce((p,c) => Math.min(p,c.length), Number.MAX_VALUE);
                return str.replace(RegExp(`^[\t ]{${minlen-1}}`,"gm"), ""); // Remove begining white spaces from each line.
            } else {
                return str;
            }
        }

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
            markdown = markdown.replace(/_(.+?)_/g, "<i>$1</i>"); // _text_ emphasize

            //```text``` code block
            markdown = markdown.replace(/\```((\s|\S)+?)\```/g, "<code><a href='#code $1'><pre>$1</pre></a></code>");
            markdown = markdown.replace(/\`(.+?)\`/g, "<code><a href='#code $1'>$1</a></code>"); // `text` code

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
    }


    background: Rectangle {
        color: 'transparent'
        border{width:1; color:palette.text}
        radius: 5
        opacity: hoverhandler.hovered ? 0.3 : 0
    }

    contentItem: TextEdit {
        id: textarea

        text: '<style>' + control.css + '</style>' +
              internals.markdownParser(internals.trimStart(control.text))

        padding: 7
        topPadding: 12

        readOnly: true
        selectByMouse: true

        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignJustify

        persistentSelection: true

        color: palette.text
        selectionColor: Qomponent.alpha(palette.highlight, 0.4)
        selectedTextColor: palette.highlightedText

        onLinkActivated: {
            if(link.startsWith("#code")) {
                copyLabel.text = "Copied!";
                Qomponent.copy(link.slice(6));
            } else {
                Qt.openUrlExternally(link);
            }
        }

        HoverHandler {
            id: hoverhandler
            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
        }

        TapHandler {
            acceptedButtons: Qt.RightButton
            onSingleTapped: (e, btn) => {
                rightClick.link = textarea.hoveredLink;
                rightClick.open();
                rightClick.x = e.position.x;
                rightClick.y = e.position.y;
            }
        }
    }

    Menu {
        id: rightClick
        property string link: ""
        width: 105; height: contentHeight
        palette.light: control.palette.highlight

        MenuItem {
            height: enabled * 20
            enabled: textarea.selectedText.length
            visible: enabled
            text: "copy selected text"
            onTriggered: {textarea.copy(); textarea.deselect()}
        }

        MenuItem {
            height: enabled * 20
            text: "copy all text"
            onTriggered: {
                textarea.selectAll();
                textarea.copy();
                textarea.deselect();
            }
        }

        MenuItem {
            height: enabled * 20
            enabled: rightClick.link
            visible: enabled
            text: rightClick.link.startsWith("#code") ? "copy code" : "copy link"
            onTriggered:Qomponent.copy(rightClick.link)
        }
    }

    Label {
        id: copyLabel
        y: 5; x: parent.width - implicitWidth - 5
        padding: 5
        text: "Copy"
        font.pointSize: 7
        opacity: textarea.hoveredLink.startsWith("#code")
        background: Rectangle {
            radius: 2; opacity: 0.5
            border { width:1; color: palette.windowText }
            color: copyLabel.text == "Copy" ? "transparent" : palette.button
        }

        Behavior on opacity { NumberAnimation {} }
        Timer {
            interval: 2500
            running: parent.text !== "Copy"
            onTriggered: parent.text = "Copy"
        }
    }
}
