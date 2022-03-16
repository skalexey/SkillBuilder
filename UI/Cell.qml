import QtQuick
import QtQuick.Controls
import SkillBuilderUI

Item {
	id: root
	width: Constants.cellHeight;
	height: Constants.cellHeight
	state: "base"
	property string cellColor: "#dbeeff"
	property int cellIndex: DelegateModel.itemsIndex
	property var attachedSkill: null

	function log(msg) {
		console.log("Cell: " + msg);
	}

	function removeCell() {
		var m = attachedSkill.getModel();
		function job() {
			attachedSkill.destroy();
			attachedSkill = null;
			m.remove();
			dmbModel.store();
		}

		if (m.get("children").size() > 0)
			messageDialog.show(
				qsTr("Warning!")
				, qsTr("The skill '" + m.get("name").value + "' has child skills. Do you want to remove it with all its children?")
				, function() {
					job();
				}
				, function() {});
		else
			job();
	}

	function detachFromParent() {
		log(this + "->detachFromParent()");
		attachedSkill.model.parent = rootSkillModel.get("children");
		dmbModel.store();
	}

	function showInfo() {
		skillInfoDialog.show(attachedSkill.getModel());
	}

	MouseArea {
		id: mouseArea
		width: parent.width
		height: parent.height
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		propagateComposedEvents: true

		function processPress(mouse) {
			if (mouse.button === Qt.RightButton)
			{
				if (!attachedSkill)
					emptyCellMenu.popup();
				else
					filledCellMenu.popup();
			}
		}

		onPressed: function(mouse) {
			processPress(mouse);
		}

		onPressAndHold: function(mouse){
			processPress(mouse);
		}

		FilledCellMenu {
			id: filledCellMenu
		}

		EmptyCellMenu {
			id: emptyCellMenu
		}

		drag.target: attachedSkill

		drag.onActiveChanged: function() {
			if (drag.active)
			{
				if (attachedSkill)
				{
					attachedSkill.originalParent = attachedSkill.parent
					attachedSkill.parent = grid;
					attachedSkill.startDrag();
					placingStrategy.onDragActive(root);
				}
			}
			else
			{
				log("skill drag stop " + root);
				placingStrategy.onDragEnd(root);
				attachedSkill.stopDrag();
				if (attachedSkill.didntMove || !attachedSkill.currentCell)
				{
					attachedSkill.didntMove = false;
					attachedSkill.parent = attachedSkill.originalParent;
					attachedSkill.x = 0;
					attachedSkill.y = 0;
					return;
				}

				attachedSkill.destroy();
				attachedSkill = null;
			}
		}

		Rectangle {
			id: cellBg
			color: cellColor
			width: parent.width
			height: parent.height
		}

		Rectangle {
			id: suggestionBg
			color: "#6896ff"
			width: parent.width
			height: parent.height
			visible: false
		}

		DropArea {
			width: parent.width
			height: parent.height

			function onDragEnd() {
				cellBg.color = cellColor;
			}

			onEntered: function(drag) {
				var enteredItem = drag.source as Skill;
				enteredItem.currentCell = root;
				if (!placingStrategy.onCellEntered(root, enteredItem))
					return;
				cellBg.color = "steelblue";
			}

			onExited: function() {
				var enteredItem = drag.source as Skill;
				if (enteredItem)
					if (enteredItem.currentCell === root)
						enteredItem.currentCell = null;
				onDragEnd();
				placingStrategy.onCellExited(root, enteredItem);
			}

			onDropped: function(drop) {
				var skillItem = (drop.source as Skill);
				if (!placingStrategy.onItemDropped(root, skillItem))
				{
					placingStrategy.hidePlaceSuggestions();
					onDragEnd();
					skillItem.didntMove = true;
					return;
				}

				onDragEnd();
			}
		}
	}
	states: [
		State {
			name: "base"
		},
		State {
			name: "suggested"

			PropertyChanges {
				target: suggestionBg
				visible: true
			}
		}
	]
	Drag.active: attachedSkill ? mouseArea.drag.active : false
}

