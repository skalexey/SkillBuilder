import QtQuick
import QtQuick.Controls

InteractiveListElement {
	// The item holder (to let the skill be detached from it)
	// and not be affected by the ListView alignments
	id: listItem
	width: parent.width
	height: skill.height

	function log(msg) {
		console.log("SkillInLibrary: " + msg);
	}

	Row {
		MouseArea {
			id: mouseArea
			width: skill.width
			height: skill.height
			propagateComposedEvents: true
			anchors.verticalCenter: parent.verticalCenter
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
				log("Skill in library pressed");
				drag.target = dummyTarget;
				//mouse.accepted = false;
			}
			onReleased: function(mouse) {
				log("Skill cell released");
				mouse.accepted = false;
			}

			drag.onActiveChanged: function() {
				log("MouseArea.drag.onActiveChanged(" + drag.active + ")");
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
		Text {
			text: skill.getModel().get("name").value
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	function removeSkill() {
		var m = skill.getModel();
		var job = function() {
			m.remove();
			dmbModel.store();
		}

		if (logic.hasSkill(m, rootSkillModel))
			messageDialog.show(
				qsTr("Warning!")
				, qsTr("Skill '" + m.get("name").value + "' has instances in the field. Do you really want to remove it with all it's instances?")
				, function() {
				   logic.removeAllSkillsOfType(m, rootSkillModel);
				   job();
				}
				, function(){}
			);
		else
		{
			job();
		}
	}

	function editSkill() {
		skillEditDialog.show(skill.getModel());
	}

	menuModel: ListModel {
		ListElement {
			title: "Info"
			cmd: function(i) {
				skillInfoDialog.show(skill.getModel());
			}
		}
		ListElement {
			title: "Edit"
			cmd: function(i) {
				editSkill();
			}
		}
		ListElement {
			title: "New from this"
			cmd: function(i) {
				skillCreationDialog.show(skill.getModel());
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
