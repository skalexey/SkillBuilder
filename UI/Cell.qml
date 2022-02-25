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
		var m = attachedSkill.model;
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

	function showInfo() {
		skillInfoDialog.show(attachedSkill.model);
	}

	MouseArea {
		id: mouseArea
		width: parent.width
		height: parent.height
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		propagateComposedEvents: true

		function processPress(mouse) {
			if (!attachedSkill)
				return;
			if (mouse.button === Qt.RightButton)
				contextMenu.popup();
		}

		onPressed: function(mouse) {
			processPress(mouse);
		}

		onPressAndHold: function(mouse){
			processPress(mouse);
		}

		Menu {
			id: contextMenu
			MenuItem {
				text: "Info"
				onClicked: showInfo()
			}
			Menu {
				id: addMenu
				title: "Add"
				Instantiator {
					model: skillLibraryModel.listModel
					onObjectAdded: function(i, o) {
						addMenu.insertItem(i, o);
					}
					onObjectRemoved: function(o) {
						addMenu.removeItem(o);
					}
					delegate: MenuItem {
						text: value.get("name").value
						onTriggered: function() {
							placingStrategy.showPlaceSuggestions(grid, root);
							var targetCell = placingStrategy.getAutoPlaceSuggestion();
							if (!targetCell)
							{
								messageDialog.show("", "No place to put the skill");
								return;
							}
							var coord = logic.getCoord(targetCell.cellIndex);
							var newModel = attachedSkill.addChild(value, coord);
							logic.placeSkill(grid, newModel, function(createdItem) {
								targetCell.attachedSkill = createdItem;
							});
							dmbModel.store();
							placingStrategy.hidePlaceSuggestions();
						}
					}
				}
			}
			MenuItem {
				text: "Remove"
				onClicked: removeCell()
			}

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

