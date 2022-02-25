import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property alias source: image.source
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

	Image {
		id: image
		anchors.verticalCenter: parent.verticalCenter
		source: source
		fillMode: Image.PreserveAspectFit
		height: parent.height
	}
}
