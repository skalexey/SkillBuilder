import QtQuick
import QtQuick.Controls
import SkillBuilderUI 1.0
import "logic.js" as Logic

Row {
	id: skill
	property var model
	property int currentCell: -1
	property string origin: "unknown"

	property var onDropped: function(i) {
		console.log("Skill.onDropped(" + i + ") from '" + origin + "'");
		var coord = Logic.getCoord(i);

		if (origin === "library")
		{
			var o = dmbModel.createObject();
			o.setPrototype(model);
			o.set("x", coord.x);
			o.set("y", coord.y);
			model = rootSkillModel().get("children").add(o);
		}
		else
		{
			model.set("x", coord.x);
			model.set("y", coord.y);
		}
		dmbModel.store();
	}

	function activeChanged() {
		console.log("connected activeChanged(" + Drag.active + ") invoked");
		if (Drag.active)
			Drag.start();
		else
		{
			//Drag.drop(); // Works only when the item is not destroyed
			if (connectedDragHandler)
			{
				connectedDragHandler.activeChanged.disconnect(activeChanged);
				connectedDragHandler.target = null;
			}
		}
	}

	property var connectedDragHandler: null

	property var startDrag: function(dragHandler) {
		console.log("Skill.startDrag()")
		if (dragHandler)
		{
			Drag.active = Qt.binding(function() {
				return dragHandler.active;
			});
			dragHandler.activeChanged.connect(activeChanged);
			connectedDragHandler = dragHandler;
		}
		else
			Drag.start();
	}

	property var stopDrag: function() {
		console.log("Skill.stopDrag()")
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
