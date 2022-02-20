import QtQuick
import QtQuick.Controls
import SkillBuilderUI
import "logic.js" as Logic

Item {
	id: root
	width: Constants.cellHeight;
	height: Constants.cellHeight

	property string cellColor: "#dbeeff"
	property int visualIndex: DelegateModel.itemsIndex
	property var attachedSkill: null

	function removeCell() {
		var m = attachedSkill.model;
		attachedSkill.destroy();
		attachedSkill = null;
		m.remove();
		dmbModel.store();
	}

	MouseArea {
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
			console.log("pressed")
			processPress(mouse);
		}

		onPressAndHold: function(mouse){
			console.log("onPressAndHold")
			processPress(mouse);
		}

		Menu {
			id: contextMenu
			MenuItem {
				text: "Move"
				onClicked: moveCell()
			}
			MenuItem {
				text: "Remove"
				onClicked: removeCell()
			}
		}

		Rectangle {
			id: cellBg
			color: cellColor
			width: parent.width
			height: parent.height
		}

		DropArea {
			width: parent.width
			height: parent.height

			function onDragEnd() {
				cellBg.color = cellColor;
			}

			onEntered: function(drag) {
				console.log("onEntered(" + visualIndex + ")");
				cellBg.color = "steelblue";
				var enteredItem = drag.source as Skill;
				enteredItem.currentCell = visualIndex;
			}

			onExited: function() {
				console.log("onExited(" + visualIndex + ")");
				var enteredItem = drag.source as Skill;
				if (enteredItem)
				{
					if (enteredItem.currentCell === visualIndex)
						enteredItem.currentCell = -1;
				}
				onDragEnd();
			}

			onDropped: function(drop) {
				console.log("Dropped at " + visualIndex);
				onDragEnd();
				var skillItem = (drop.source as Skill);
				skillItem.onDropped(visualIndex);
				Logic.placeSkill(grid, skillItem.model, function(createdItem) {
					attachedSkill = createdItem;
				});
			}
		}
	}
}

