import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property alias textInput: textInput
	property alias enteredText: textInput.text
	property string title: qsTr("Row")

	Text {
		id: textLabel
		text: title
		anchors.verticalCenter: parent.verticalCenter
	}

	Item {
		width: 12
		height: parent.height
	}

	TextField {
		id: textInput
		anchors.verticalCenter: parent.verticalCenter
	}
}
