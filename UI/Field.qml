import QtQuick
import QtQuick.Controls
import QtQml.Models
import SkillBuilderUI 1.0

ScrollView {
	width: parent.width
	height: parent.height
	clip: true

	property alias grid: grid

	Grid {
		id: grid
		anchors.margins: 5
		width: Constants.cellWidth * columns
		height: Constants.cellHeight * rows
		columns: Constants.fieldSize
		rows: Constants.fieldSize
		columnSpacing: 0 // 1 // for net-like grid
		rowSpacing: 0 // 1 // for net-like grid

		Repeater {
			model: grid.columns * grid.rows;
			delegate: Cell {}
		}
	}

	Component.onCompleted: function() {
		logic.placeSkillsOnField(grid, rootSkillModel);
	}
}

