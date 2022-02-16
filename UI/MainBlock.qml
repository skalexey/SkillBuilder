import QtQuick
import QtQuick.Controls
import "logic.js" as Logic

Row {
	id: mainBlock
	width: parent.width
	height: parent.height
	visible: false

	Column {
		id: leftBlock
		width: parent.width * 0.25
		height: parent.height
		z: 1

		Text {
			id: skillLibraryTitle
			text: "Skill library"
			anchors.horizontalCenter: parent.horizontalCenter
		}

		ListView {
			id: skillLibraryList
			width: parent.width
			implicitHeight: contentItem.childrenRect.height
			model: dmbModel.contentModel.get("skillLibrary").listModel

			delegate: Item {
				// The item holder (to let the skill be detached from it)
				// and not be affected by the ListView alignments
				id: listItem
				width: parent.width
				height: skill.height

				MouseArea {
					id: mouseArea
					width: parent.width
					height: parent.height

					drag.target: null
					onPressed: function(mouse) {
						console.log("Skill cell pressed");
						Logic.createSkill(skill, function(createdSkill) {
							createdSkill.x = listItem.x;
							createdSkill.y = listItem.y;
							Logic.initDrag(createdSkill, drag);
						});
					}

					drag.onActiveChanged: function() {
						console.log("MouseArea.drag.onActiveChanged(" + drag.active + ")");
						if (!drag.active)
							Logic.destroyDraggableItem(drag);
					}

					Skill {
						id: skill
						model: value
						fieldRef: field
					}
				}
			}
		}
	}

	Field {
		id: field
		width: parent.width - leftBlock.width
		height: parent.height
	}

}
