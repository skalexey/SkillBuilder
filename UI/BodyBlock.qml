import QtQuick
import QtQuick.Controls
import QVL 1.0

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

	MainBlock {
		id: mainBlock
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
	D{i:0;formeditorZoom:0.66}D{i:1}D{i:3}D{i:2}
}
##^##*/
