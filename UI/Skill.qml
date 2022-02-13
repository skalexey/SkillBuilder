import QtQuick
import QtQuick.Controls

Row {
	property var model
	width: parent.width
	height: 80
	Rectangle {
		width: 50
		height: 50
		color: "green"
	}
	Text {
		text: model.get("name").value
	}
}
