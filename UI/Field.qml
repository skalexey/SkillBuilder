import QtQuick
import QtQuick.Controls
import QtQml.Models
import SkillBuilderUI 1.0

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

				function onDragEnd(drag) {
					cellBg.color = cellColor;
				}

				onEntered: function(drag) {
					cellBg.color = "steelblue";
				}

				onExited: function(drag) {
					onDragEnd(drag);
				}

				onDropped: function(drop) {
					console.log("Dropped at " + visualIndex);
					onDragEnd(drag);
					(drop.source as Skill).onDropped(visualIndex);
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
}

