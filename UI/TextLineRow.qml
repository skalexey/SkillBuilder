import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width
	height: textValue.height

	property alias value: textValue.text
	property string title: qsTr("Row")
	property bool tooltip: false

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
		verticalAlignment: Text.AlignVCenter
		width: parent.width - textLabel.width - spacer.width
		clip: true
		ToolTip.text: text
		ToolTip.visible: tooltip && ma.containsMouse
		MouseArea {
			id: ma
			anchors.fill: parent
			hoverEnabled: true
			visible: tooltip
		}
	}
}
