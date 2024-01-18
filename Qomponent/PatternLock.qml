// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Shapes

Control {
    id: control

    component Circle: Rectangle {
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        width: 5 + 2 * border.width; height: width; radius: width
        opacity: 0.8
        color: control.palette.button

        border.color: Qomponent.alpha(color, 0.5)
        border.width: 0

        Behavior on border.width {NumberAnimation{ duration: 150 }}
    }

    component SP: ShapePath {
        fillColor: 'transparent'
        strokeWidth: 1
        strokeColor: control.palette.button
        scale: Qt.size(shape.width, shape.height)
    }

    signal press()
    signal release()
    signal added(index: int, point: point)

    property int rows: 3
    property int columns: 3
    property real snapMargin: 15
    readonly property ListModel path: ListModel{}

    function clear() {
        path.clear();
        internals.visited = Array(rows * columns).fill(0);
    }

    function toArray() {
        return Array(path.count).fill().map((_,i) => path.get(i).id);
    }

    QtObject {
        id: internals
        /// Visited points
        property var visited: Array(rows * columns).fill(0);
        /// Size of grid tiles
        property point grid: Qt.point(availableWidth/columns, availableHeight/rows);
        /// Position of mouse
        property alias pos: pointHandler.point.position;
        /// Normal position of mouse (x: 0..1, y: 0..1)
        property point norm: Qt.point(pos.x/availableWidth, pos.y/availableHeight);
        /// Position of tile under the mouse
        property point cell: Qt.point(Math.floor(norm.x * columns), Math.floor(norm.y * rows));
        property point last: {
            const end = path.get(path.count - 1) ?? {};
            return Qt.point(end.x || 0, end.y || 0);
        }
        property bool full: path.count === rows * columns;
        property bool valid: {
            /// Position of mouse relative to the tile
            const gx = pos.x % grid.x - grid.x/2,
                  gy = pos.y % grid.y - grid.y/2,
                  {x, y} = norm;
            const dist = Math.sqrt(gx*gx + gy*gy);
            return dist < snapMargin && pointHandler.active &&
                    !internals.full && 0 < x && x < 1 && 0 < y && y < 1;
        }

        function modelToPath(model) {
            return Array(model.count).fill().map((_,i) => {
                const {x,y} = model.get(i);
                return Qt.point((x + 0.5)/columns, (y + 0.5)/rows);
            });
        }

        onNormChanged: {
            const id = cell.y * columns + cell.x;
            if(!visited[id] && pointHandler.active && valid) {
                path.append({x:cell.x, y:cell.y, id: id});
                visited[id] = true;
                // emit signal
                control.added(id, cell);
            }
        }
    }

    contentItem: Item {
        Grid {
            columns: control.columns
            Repeater {

                model: rows * columns
                Item {
                    width: internals.grid.x
                    height: internals.grid.y

                    required property int index
                    /// Position of tile
                    property point pos: Qt.point(index%columns, Math.floor(index/columns));

                    Circle {
                        border.width: internals.valid && parent.pos == internals.cell ? 10 : 0;
                    }
                }
            }
        }

        Shape {
            id: shape
            clip: true
            width: parent.width
            height: parent.height

            /// Polygon shape
            SP { PathPolyline { path: internals.modelToPath(control.path) } }
            /// Line to mouse position
            SP {
                strokeColor: pointHandler.active && path.count && !internals.full ?
                                 Qomponent.alpha(control.palette.button, 0.5) : 'transparent'
                startX: (internals.last.x + 0.5)/columns
                startY: (internals.last.y + 0.5)/rows
                PathLine {
                    x: internals.norm.x
                    y: internals.norm.y
                }
            }
        }

        DragHandler { target: null }

        PointHandler {
            id: pointHandler
            onActiveChanged: active ? control.press() : control.release()
        }
    }
}
