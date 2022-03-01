import QtQuick
import QtQuick.Controls
import SkillBuilderUI 1.0

Item {
	id: skill
	width: 64
	height: 64
	z: 1
	//anchors.verticalCenter: parent.verticalCenter

	Rectangle {
		id: parentIndicator
		width: parent.width
		height: parent.height
		color: "#a9fc7a"
		visible: false
	}

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

	property var model
	property var currentCell: null
	property string origin: "unknown"
	property var originalParent: null
	property bool didntMove: false
	property var stateParent: function() {
		state = "parent";
	}
	property var stateBase: function() {
		state = "base";
	}

	function log(msg) {
		console.log("Skill: " + msg);
	}

	property var addChild: function(protoModel, coord)	{
		var o = dmbModel.createObject();
		o.setPrototype(protoModel);
		o.set("x", coord.x);
		o.set("y", coord.y);
		o.set("children", dmbModel.createList());
		return model.get("children").add(o);
	}

	property var onDropped: function(i, parentModel) {
		log("onDropped(" + i + ") from '" + origin + "'");
		var coord = logic.getCoord(i);
		if (!parentModel)
			log("onDropped: Error! No parent model specified")
		var finalParentModel = parentModel ? parentModel : rootSkillModel.get("children");
		if (origin === "library")
		{
			var o = dmbModel.createObject();
			o.setPrototype(model);
			o.set("x", coord.x);
			o.set("y", coord.y);
			o.set("children", dmbModel.createList());
			model = finalParentModel.add(o);
		}
		else
		{
			if (model.parent !== finalParentModel)
				model.parent = finalParentModel;
			model.set("x", coord.x);
			model.set("y", coord.y);
		}
		dmbModel.store();
	}

	function doStartDrag() {
		Drag.hotSpot.x = skill.width / 2;
		Drag.hotSpot.y = skill.height / 2;
		Drag.start();
	}

	function activeChanged() {
		log("connected activeChanged(" + Drag.active + ") invoked");
		if (Drag.active)
		{
			doStartDrag();
		}
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
		log("startDrag()");
		if (dragHandler)
		{
			Drag.active = Qt.binding(function() {
				return dragHandler.active;
			});
			dragHandler.activeChanged.connect(activeChanged);
			connectedDragHandler = dragHandler;
		}
		else
		{
			doStartDrag();
		}
	}

	property var stopDrag: function() {
		log("stopDrag()")
		Drag.drop();
	}

	states: [
		State {
			name: "base"
		},
		State {
			name: "parent"

			PropertyChanges {
				target: parentIndicator
				visible: true
			}
		}
	]
}
