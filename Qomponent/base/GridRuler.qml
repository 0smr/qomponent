// Copyright (C) 2022 smr.
// SPDX-License-Identifier: MIT
// https://0smr.github.io

import QtQuick 2.15
import QtQuick.Controls 2.15

import Qomponent 0.1

Control {
	id: control
	property alias step: effect.step
	property alias offset: effect.offset
	property alias color: effect.color
	property alias origin: effect.origin

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
			readonly property vector2d hw: Qt.vector2d(width, height)

			fragmentShader: "qrc:/Qomponent/shader/grid-ruler.glsl"

			DragHandler {
				property vector2d init: Qt.vector2d(0,0)
				target: null
				dragThreshold: 0
				onActiveChanged: if(active) init = parent.offset;
				onTranslationChanged: parent.offset = Qt.vector2d(init.x - translation.x, init.y - translation.y);
			}
		}

		Repeater {
			model: ['x','y']
			Repeater {
				property int gstep: control.step[modelData]
				property int goffset: control.offset[modelData]
				property bool horizontal: modelData === 'x'
				property real dist: horizontal ? parent.width : parent.height

				model: dist/gstep + 1

				delegate: Label {
					property int idx: index - 1
					property real pos: idx * gstep - goffset % gstep + (dist/2 % gstep)
					property bool needsRotate: horizontal && gstep < (implicitWidth + 5)

					x: horizontal && pos
					y: !horizontal && pos
					text: [y,x][horizontal * 1] - dist/2 + goffset

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
