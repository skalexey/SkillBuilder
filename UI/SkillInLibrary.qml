import QtQuick
import QtQuick.Controls
import "logic.js" as Logic

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
//						if (item.currentCell < 0)
					Logic.destroyDraggableItem(drag);
//						else
//							Logic.stopDrag(drag);
			}
			else
			{
				Logic.createSkill(skill, skillLibraryList, function(createdSkill) {
					createdSkill.x = listItem.x;
					createdSkill.y = listItem.y;
					createdSkill.origin = "library";
					Logic.initDrag(createdSkill, drag);
				});
			}
		}

		Skill {
			id: skill
			model: value
		}
	}

	function removeSkill() {
		// TODO: replace rootSkillModel() with rootSkillModel
		if (Logic.hasSkill(skill.model, rootSkillModel()))
			dialogRemoveSkillWarning.show(skill.model);
		else
		{
			skill.model.remove();
			dmbModel.store();
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
