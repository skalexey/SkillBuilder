import QtQuick
import QtQuick.Controls
import SkillBuilderUI

Row {
	id: mainBlock
	width: parent.width
	height: parent.height
	visible: false

	property alias field: field
	property alias grid: field.grid

	Item {
		id: leftBlock
		width: parent.width * 0.25
		height: parent.height
		z: 1

		SkillLibrary {

		}
	}

	Field {
		id: field
		width: parent.width - leftBlock.width
		height: parent.height
	}

}
