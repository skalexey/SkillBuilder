import QtQuick
import QtQuick.Controls
import QtQml.Models
import SkillBuilderUI 1.0

ScrollView {
	width: parent.width
	height: parent.height
	clip: true

	property alias grid: grid
	property alias gg: grid

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
		logic.placeSkillsOnField(grid, rootSkillModel);
	}
}

