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

	Item {
		id: mainBlock
		width: parent.width
		height: parent.height
		visible: false

		Column {
			id: leftBlock
			width: parent.width * 0.25
			height: parent.height

			Text {
				id: skillLibraryTitle
				text: "Skill library"
				anchors.horizontalCenter: parent.horizontalCenter
			}

			ListView {
				width: parent.width
				implicitHeight: contentItem.childrenRect.height
				id: skillLibraryList
				model: dmbModel.contentModel.get("skillLibrary").listModel
				delegate: Skill {
					model: value
				}
			}
			Text {
				id: sdi
				text: dmbModel.contentModel.get("skillLibrary").listModel.rowCount();
			}
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
	D{i:0;formeditorZoom:0.66}D{i:3}D{i:4}D{i:2}D{i:1}D{i:7}D{i:6}
}
##^##*/
