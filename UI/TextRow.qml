import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property alias value: textValue.text
	property string title: qsTr("Row")

	Text {
		id: textLabel
		text: title
		anchors.verticalCenter: parent.verticalCenter
	}

	Item {
		id: spacer
		width: 12
		height: parent.height
	}

	Text {
		id: textValue
		anchors.verticalCenter: parent.verticalCenter
		height: parent.height
		width: parent.width - textLabel.width - spacer.width
		clip: true
		wrapMode: Text.Wrap
	}
}
