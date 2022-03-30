import QtQuick
import QtQuick.Controls
import SkillBuilderUI 1.0

Item {
	id: skill
	width: 64
	height: 64
	z: 1
	//anchors.verticalCenter: parent.verticalCenter

	property var model;
	onModelChanged: function() {
		setModel(model);
	}

	QtObject {
		id: local
		property var model
	}

	property var setModel: function(model) {
		if (model)
		{
			log("setModel " + model + ", " + model.get("name").value);
			local.model = model;
		}
	}

	property var getModel: function() {
		return local.model;
	}

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
		return logic.instantiateSkillIntoSkill(protoModel, local.model, coord);
	}

	property var onDropped: function(i, parentModel) {
		log("onDropped(" + i + ") from '" + origin + "'");
		var coord = logic.getCoord(i);
		if (!parentModel)
			log("onDropped: Error! No parent model specified")
		var finalParentModel = parentModel ? parentModel : rootSkillModel;
		if (origin === "library")
			model = logic.instantiateSkillIntoSkill(local.model, finalParentModel, coord);
		else
		{
			var c = finalParentModel.get("children");
			if (local.model.parent !== c)
				local.model.parent = c;
			local.model.set("x", coord.x);
			local.model.set("y", coord.y);
		}
		dmbModel.store();
	}

	Rectangle {
		id: parentIndicator
		width: parent.width
		height: parent.height
		color: "#a9fc7a"
		visible: false
	}

	BorderImage {
		id: borderImage
		width: parent.width
		height: parent.height
		anchors.verticalCenter: parent.verticalCenter
		source: local.model.get("frameImgPath").value
		anchors.horizontalCenter: parent.horizontalCenter
	}

	Image {
		id: image
		width: 54
		height: 54
		anchors.verticalCenter: parent.verticalCenter
		source: local.model.get("iconPath").value
		anchors.horizontalCenter: parent.horizontalCenter
		fillMode: Image.PreserveAspectFit
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
