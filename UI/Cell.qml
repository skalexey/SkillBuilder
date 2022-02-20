import QtQuick
import QtQuick.Controls
import SkillBuilderUI
import "logic.js" as Logic

DropArea {
	id: delegateRoot

	property string cellColor: "#dbeeff"

	width: Constants.cellHeight;
	height: Constants.cellHeight

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
			//local.enteredItem = null;
		}
		onDragEnd();
	}

	onDropped: function(drop) {
		console.log("Dropped at " + visualIndex);
		onDragEnd();
		var skillItem = (drop.source as Skill);
		skillItem.onDropped(visualIndex);
		Logic.placeSkill(grid, skillItem.model);
	}

	property int visualIndex: DelegateModel.itemsIndex

	Rectangle {
		id: cellBg
		color: cellColor
		width: parent.width
		height: parent.height
	}
}

