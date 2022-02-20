import QtQuick
import QtQuick.Controls
import QtQml.Models
import SkillBuilderUI 1.0
import "logic.js" as Logic

ScrollView {
	width: parent.width
	height: parent.height
	clip: true

	Grid {
		id: grid
		anchors.margins: 5
		width: Constants.cellWidth * columns
		height: Constants.cellHeight * rows
		columns: Constants.fieldSize
		rows: Constants.fieldSize
		columnSpacing: 1
		rowSpacing: 1

		Repeater {
			model: grid.columns * grid.rows;
			delegate: DropArea {
				id: delegateRoot

				property string cellColor: "#dbeeff"

				width: Constants.cellHeight;
				height: Constants.cellHeight

//				QtObject {
//					id: local
//					property var enteredItem: null
//				}

				function onDragEnd() {
					cellBg.color = cellColor;
				}

				onEntered: function(drag) {
					console.log("onEntered(" + visualIndex + ")");
					console.log("this.drag.coord: " + this.drag.x + ", " + this.drag.y);
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
		}
	}

	Component.onCompleted: function() {
		var rootSkill = dmbModel.contentModel.get("rootSkill");
		if (rootSkill)
		{
			var rootSkillList = rootSkill.get("children");
			if (rootSkillList)
			{
				var listModel = rootSkillList.listModel;
				var sz = listModel.rowCount();
				console.log(sz + " skills in the tree");
				for (var i = 0; i < sz; i++)
				{
					var m = listModel.at(i);
					console.log("Iterate skill in the tree: '" + m.get("name").value + "' at position " + m.get("x").value + ", " + m.get("y").value);
					Logic.placeSkill(grid, m);
				}
			}
			else
			{
				console.log("Error! There is no 'children' field in the rootSkill node");
			}
		}
		else
		{
			console.log("Error! There is no skill tree (rootSkill) in the content");
		}
	}
}

