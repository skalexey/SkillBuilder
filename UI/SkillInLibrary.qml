import QtQuick
import QtQuick.Controls

InteractiveListElement {
	// The item holder (to let the skill be detached from it)
	// and not be affected by the ListView alignments
	id: listItem
	width: parent.width
	height: skill.height

	MouseArea {
		id: mouseArea
		width: parent.width
		height: parent.height
		propagateComposedEvents: true
		// Needed to initiate the drag without a skill item instantiation
		Item {
			property var startDrag: function() {
				Drag.start();
			}

			property var stopDrag: function() {
				Drag.drop();
			}
		}

		Item {
			id: dummyTarget
			width: 50
			height: 50
		}

		drag.target: null
		onPressed: function(mouse) {
			console.log("Skill in library pressed");
			drag.target = dummyTarget;
			//mouse.accepted = false;
		}
		onReleased: function(mouse) {
			console.log("Skill cell released");
			mouse.accepted = false;
		}

		drag.onActiveChanged: function() {
			console.log("MouseArea.drag.onActiveChanged(" + drag.active + ")");
			if (!drag.active)
			{
				var item = drag.target as Skill;
//						if (item.currentCell.cellIndex < 0)
					logic.destroyDraggableItem(drag);
//						else
//							logic.stopDrag(drag);
			}
			else
			{
				logic.createSkill(skill, skillLibraryList, function(createdSkill) {
					createdSkill.x = listItem.x;
					createdSkill.y = listItem.y;
					createdSkill.origin = "library";
					logic.initDrag(createdSkill, drag);
				});
			}
		}

		Skill {
			id: skill
			model: value
		}
	}

	function removeSkill() {
		var m = skill.model;
		var job = function() {
			m.remove();
			dmbModel.store();
		}

		if (logic.hasSkill(m, rootSkillModel))
			messageDialog.show(qsTr("Warning!")
				, qsTr("Skill '" + m.get("name").value + "' has instances in the field. Do you really want to remove it with all it's instances?")
				, function() {
				   logic.removeAllSkillsOfType(m, rootSkillModel);
				   job();
				});
		else
		{
			job();
		}
	}

	function editSkill() {
		skillInfoDialog.show(skill.model);
	}

	menuModel: ListModel {
		ListElement {
			title: "Edit"
			cmd: function(i) {
				editSkill();
			}
		}
		ListElement {
			title: "Remove"
			cmd: function(i) {
				removeSkill();
			}
		}
	}
}
