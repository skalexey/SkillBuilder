import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property alias source: image.source

	property string title: qsTr("Row")

	property var recalculate: function() {
		loader.width = loader.item.width;
		loader.height = loader.item.height;
	}

	property var textLabelComponent: Component {
		id: comp
		Text {
			id: textItem
			text: title
		}
	}

	Loader {
		id: loader
		sourceComponent: textLabelComponent;
		anchors.verticalCenter: parent.verticalCenter

		onLoaded: function() {
			loader.width = loader.item.width;
			loader.height = loader.item.height;
		}
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

	Component.onCompleted: function() {
	}
}
