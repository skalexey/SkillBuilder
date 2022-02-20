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
			delegate: Cell {}
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

