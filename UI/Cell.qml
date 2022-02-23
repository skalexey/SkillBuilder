import QtQuick
import QtQuick.Controls
import SkillBuilderUI

Item {
	id: root
	width: Constants.cellHeight;
	height: Constants.cellHeight
	state: "base"
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

		drag.target: attachedSkill

		drag.onActiveChanged: function() {
			if (drag.active)
			{
				if (attachedSkill)
				{
					console.log("attachedSkill detached");
					attachedSkill.parent = grid;
					attachedSkill.startDrag();
				}
			}
			else
			{
				console.log("Cell: skill drag stop");
				attachedSkill.stopDrag();
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
				console.log("onEntered(" + visualIndex + ")");
				cellBg.color = "steelblue";
				var enteredItem = drag.source as Skill;
				enteredItem.currentCell = visualIndex;
				if (attachedSkill)
					logic.showPlaceSuggestions(grid, root);
				else if (logic.isSuggestedCell(root))
					logic.addSuggestionsUser(root);
				else if (logic.placeSuggestionsActive())
					logic.hidePlaceSuggestions();
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
				if (logic.isTheOnlySuggestionsUser(root))
					logic.hidePlaceSuggestions(true);
				else
					logic.removeSuggestionsUser(root);
			}

			onDropped: function(drop) {
				console.log("Dropped at " + visualIndex);
				onDragEnd();
				logic.hidePlaceSuggestions();
				var skillItem = (drop.source as Skill);
				skillItem.onDropped(visualIndex);
				logic.placeSkill(grid, skillItem.model, function(createdItem) {
					attachedSkill = createdItem;
				});
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

