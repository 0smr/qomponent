// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick
import QtQuick.Controls.Basic

import qomponent 0.2

Control {
	id: control
	property alias step: effect.step
	property alias offset: effect.offset
	property alias color: effect.color
	property alias origin: effect.origin
	property alias interactive: draghandler.enabled
	property alias drag: draghandler
	property var filter: undefined

	contentItem: Item {
		clip: true
		ShaderEffect {
			id: effect
			width: control.availableWidth
			height: control.availableHeight

			property color color: '#488'
			property color origin: '#fff'
			property vector2d step: Qt.vector2d(20, 20)
			property vector2d offset: Qt.vector2d(0, 0)
			property vector2d size: Qt.vector2d(width, height)

			fragmentShader: "qrc:/qomponent/shader/grid-ruler.frag.qsb"

			DragHandler {
				id: draghandler
				property vector2d init: Qt.vector2d(0,0)
				target: null
				dragThreshold: 0
				onActiveChanged: if(active) init = parent.offset;
				onTranslationChanged: parent.offset = init.minus(Qt.vector2d(translation.x, translation.y));
			}
		}

		Repeater {
			model: ['x','y']
			Repeater {
				property bool horizontal: modelData === 'x'
				property real gstep: control.step[modelData]
				property real goffset: control.offset[modelData]
				property real dist: horizontal ? parent.width : parent.height

				model: dist/gstep + 2

				delegate: Label {
					property int idx: index - 1
					property real pos: idx * gstep - goffset % gstep + (dist/2 % gstep)
					property bool needsRotate: horizontal && gstep < (implicitWidth + 5)
					readonly property real value: ([y,x][horizontal * 1] - dist/2 + goffset)

					x: horizontal && pos
					y: !horizontal && pos
					text: filter ? filter(value, horizontal) : value

					opacity: x/20 + y
					font.family: Qomponent.monofont.name
					font.pixelSize: 8

					rotation: needsRotate ? 90 : 0
					transformOrigin: Item.TopLeft
					transform: Translate{x: needsRotate * font.pixelSize + 1}
				}
			}
		}
	}
}
