// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://smr76.github.io

import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.12

Control {
    id: control
    width:  225
    height: 390
    visible: true

    QtObject {
        id: rearrange

        function arrangeModel() {
            let layoutColums = gridLayout.columns;
            let matrix = Array(1).fill(Array(layoutColums).fill(0))
            let modelIndex = 0;
            let i = -1, l = 0;
            let itemsOldPos = [];
            while(l < listModel.count) {
                const item = repeater.itemAt(l++);
                itemsOldPos.push({x:item.x, y:item.y});
            }

            while(modelIndex < listModel.count) {
                ++i;
                for(let j = 0 ; j < layoutColums && modelIndex < listModel.count; ++j) {
                    const rc = remainedCols(matrix, i , j);
                    if(rc > 0) {
                        const index = findLargestItem(modelIndex, rc);
                        const item = listModel.get(index);
                        if(item.rowSpan + i >= matrix.length - 1) {
                            let newRows = item.rowSpan + i - matrix.length + 1;
                            while(newRows-- > 0){
                                matrix.push(Array(layoutColums).fill(0));
                            }
                        }
                        listModel.move(index, modelIndex, 1);
                        modelIndex++;
                        fillMatrix(matrix, i, j, item.rowSpan, item.colSpan);
                    }
                }
            }

//            for(let m = 0; m < listModel.count; m++) {
//                let initialIndex = listModel.get(m).itemIndex;
//                var a = itemsOldPos[initialIndex];
//                var b = repeater.itemAt(m);
//                b.x = a.x;
//                b.y = a.y;
//            }
        }

        function findLargestItem(startPos, remainedColumns) {
            let bItem = {index: startPos, size: 0}
            for(let i = startPos ; i < listModel.count; ++i) {
                let item = listModel.get(i)
                let itemSize = item.rowSpan * item.colSpan;

                if(item.colSpan <= remainedColumns && itemSize > bItem.size) {
                    bItem = {index: i, size: itemSize}
                }
            }
            return bItem.index;
        }

        function remainedCols(matrix, i, j) {
            let col = matrix[0].length;
            let k = 0;
            while(j + k < col && matrix[i][j + k] === 0) {
                k++;
            }
            return k;
        }

        function fillMatrix(matrix, i, j, row, col) {
            for(let m = 0; m < row; ++m){
                for(let n = 0; n < col; ++n){
                    matrix[i+m][j+n] = 1;
                }
            }
        }
    }

    QtObject {
        id: randomSpan

        function setItemsSpan() {
            let layoutColums = gridLayout.columns;
            let matrix = Array(1).fill(Array(layoutColums).fill(0))
            let modelIndex = 0;

            for(let i = 0; modelIndex < listModel.count ; ++i) {
                for(let j = 0; j < layoutColums && modelIndex < listModel.count; ++j) {
                    let rc = rearrange.remainedCols(matrix, i, j);
                    if(rc > 0) {
                        const item = listModel.get(modelIndex++);
                        item.rowSpan = randomSpan.randNaturalNum(rc);
                        item.colSpan = randomSpan.randNaturalNum(rc);
                        if(item.rowSpan + i >= matrix.length - 1) {
                            let newRows = item.rowSpan + i - matrix.length + 1;
                            while(newRows-- > 0){
                                matrix.push(Array(layoutColums).fill(0));
                            }
                        }
                        rearrange.fillMatrix(matrix, i, j, item.rowSpan, item.colSpan);
                        j += item.colSpan - 1; // skip columns
                    }
                }
            }
            // BUG: update list model data doesn't effect the repeater
            repeater.model = null
            repeater.model = listModel
        }

        function randNaturalNum(max) {
            return max <= 1 ? 1 : Math.floor(Math.random() * (max - 1)) + 1;
        }
    }

    function listModelToText() {
        let x = "";
        for(let i = 0; i < listModel.count; ++i) {
            let item = listModel.get(i);
            x += "%1(%2,%3) ".arg(item.itemIndex).arg(item.rowSpan).arg(item.colSpan)
        }
        return x;
    }

    ListModel {
        id: listModel
        ListElement { rowSpan: 1; colSpan: 2; itemIndex: 0; hslHue: 0.18 }
        ListElement { rowSpan: 2; colSpan: 1; itemIndex: 1; hslHue: 0.23 }
        ListElement { rowSpan: 1; colSpan: 1; itemIndex: 2; hslHue: 0.38 }
        ListElement { rowSpan: 1; colSpan: 1; itemIndex: 3; hslHue: 0.48 }
        ListElement { rowSpan: 2; colSpan: 2; itemIndex: 4; hslHue: 0.55 }
        ListElement { rowSpan: 1; colSpan: 2; itemIndex: 5; hslHue: 0.00 }
        ListElement { rowSpan: 2; colSpan: 1; itemIndex: 6; hslHue: 0.78 }
        ListElement { rowSpan: 1; colSpan: 3; itemIndex: 7; hslHue: 0.90 }
        onRowsMoved: text.text = listModelToText()
    }

    contentItem:
        Column {
            padding: 5
            spacing: 5

            TextArea {
                id: text
                width: control.width; height: 10
                padding: 0
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 8
                selectByMouse: true
                selectionColor: '#55000000'
                readOnly: true
                text: listModelToText()
            }

            Row {
                spacing: 5
                Button {
                    width: 40; height: 20
                    text: '\uf522'
                    palette.button: '#FF473D'
                    palette.buttonText: 'white'
                    font.family: 'font awesome 5 pro solid'
                    onClicked: {
                        randomSpan.setItemsSpan();
                    }
                }

                Button {
                    width: 40; height: 20
                    text: '\uf88e'
                    palette.button: '#FF473D'
                    palette.buttonText: 'white'
                    font.family: 'font awesome 5 pro solid'
                    onClicked: {
                        rearrange.arrangeModel();
                    }
                }

                Button {
                    width: 40; height: 20
                    palette.button: '#FF473D'
                    palette.buttonText: 'white'
                    font.family: 'font awesome 5 pro solid'
                    text: '\uf00d'
                    onClicked: {
                        Qt.quit()
                    }
                }
            }

            GridLayout {
                id: gridLayout
                columns: 4
                Repeater {
                    id: repeater
                    model: listModel
                    delegate: Item {
                        id: delegateItem
                        property int idx: index

                        GridLayout.preferredWidth: 55 * colSpan - 5
                        GridLayout.preferredHeight: 55 * rowSpan - 5

                        GridLayout.columnSpan: colSpan
                        GridLayout.rowSpan: rowSpan

                        opacity: mousearea.drag.active ? 0.8 : 1
                        z: rect.x + rect.y != 0 ? 10 : 1

                        Behavior on x { NumberAnimation {duration: 100} }
                        Behavior on y { NumberAnimation {duration: 100} }

                        Rectangle {
                            anchors.fill: parent
                            border.width: 1
                            border.color: '#007BC7'
                            color: '#993DB5FF'
                            opacity: 0.5
                        }

                        Rectangle {
                            id: rect
                            width: parent.width; height: parent.height
                            color: Qt.hsla(hslHue, 0.9, 0.5, 1.0)

                            Text {
                                anchors.centerIn: parent
                                font.bold: true
                                color: 'white'
                                opacity: 0.7
                                text: itemIndex
                            }

                            Drag.active: mousearea.drag.active
                            Drag.hotSpot.x: width/2
                            Drag.hotSpot.y: height/2

                            Behavior on x { NumberAnimation {duration: 100} }
                            Behavior on y { NumberAnimation {duration: 100} }
                        }

                        MouseArea {
                            id: mousearea
                            anchors.fill: parent
                            drag.target: rect
                            drag.threshold: 2
                            drag.onActiveChanged: if(!drag.active) rect.x = rect.y = 0
                        }

                        DropArea {
                            id: droparea
                            anchors.fill: parent;
                            onEntered: {
                                let destIdx = delegateItem.idx;
                                let srcIdx = drag.source.parent.idx;
                                if(srcIdx !== destIdx) {
                                    var a = repeater.itemAt(destIdx);
                                    var b = repeater.itemAt(srcIdx);
                                    [a.x, b.x] = [b.x, a.x];
                                    [a.y, b.y] = [b.y, a.y];

//                                    listModel.move(srcIdx, destIdx, 1)
                                }
                            }

                            onDropped: {
                                print('hi')
                            }
                        }
                    }
                }
            }
        }
}
