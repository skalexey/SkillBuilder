import QtQuick
import QtQuick.Controls

Column {
	id: row
	width: parent.width
	height: 200
	property alias textInput: textInput
	property alias enteredText: textInput.text
//	property alias placeholderText: textInput.placeholderText
	property string title: qsTr("Row")

	Text {
		id: textLabel
		text: title
	}

	Item {
		width: parent.width
		height: 12
	}


	TextEdit {
		id: textInput
		height: 100
		width: parent.width
		wrapMode: TextEdit.WordWrap
	}
}
