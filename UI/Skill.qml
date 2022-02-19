import QtQuick
import QtQuick.Controls

Row {
	id: skill
	property var model
	property int currentCell: -1

	property var onDropped: function(i) {
		console.log("Skill.onDropped(" + i + ")");
	}

	property var startDrag: function(dragHandler) {
		if (dragHandler)
		{
			Drag.active = Qt.binding(function() {
				return dragHandler.active;
			});
			dragHandler.activeChanged.connect(function() {
				if (Drag.active)
					Drag.start();
				else // Works only when the item is not destroyed
					Drag.drop();
			});
		}
	}

	property var stopDrag: function() {
		Drag.drop();
	}

	width: parent.width
	height: 80

	Item {
		id: icon
		width: 64
		height: 64
		anchors.verticalCenter: parent.verticalCenter

		Image {
			id: image
			width: 54
			height: 54
			anchors.verticalCenter: parent.verticalCenter
			source: model.get("iconPath").value
			anchors.horizontalCenter: parent.horizontalCenter
			fillMode: Image.PreserveAspectFit
		}

		BorderImage {
			id: borderImage
			width: parent.width
			height: parent.height
			anchors.verticalCenter: parent.verticalCenter
			source: model.get("frameImgPath").value
			anchors.horizontalCenter: parent.horizontalCenter
		}
	}

	Text {
		text: model.get("name").value
		anchors.verticalCenter: parent.verticalCenter
	}
}
