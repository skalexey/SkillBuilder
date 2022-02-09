import QtQuick
import QtQuick.Controls

Item {
	id: bodyBlock
	y: topBlock.y + topBlock.height
	width: parent.width
	height: parent.height - topBlock.height - topBlock.y
	state: "loaded"

	property alias mainBlock: mainBlock

	property var stateLoaded: function() {
		state = "loaded";
	}
	property var stateLoadDatabaseError: function() {
		state = "loadDatabaseError";
	}

	Item {
		id: mainBlock
		width: parent.width
		height: parent.height
		visible: false

		Button {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			text: "Hello"
		}
	}

	Item {
		id: errorBlock
		width: parent.width
		height: parent.height
		visible: false

		Text {
			text: "Open database error"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}

	states: [
		State {
			name: "loaded"

			PropertyChanges {
				target: mainBlock
				visible: true
			}
		},
		State {
			name: "loadDatabaseError"

			PropertyChanges {
				target: errorBlock
				visible: true
			}
		}
	]
}

/*##^##
Designer {
	D{i:0;formeditorZoom:0.66}D{i:2}D{i:1}D{i:4}D{i:3}
}
##^##*/
