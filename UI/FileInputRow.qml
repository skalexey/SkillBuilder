import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property var chosenFile
	property string title: qsTr("Row")
	property var chosenFilePath: chosenFileInput.text

	Text {
		id: textLabel
		text: title
		anchors.verticalCenter: parent.verticalCenter
	}

	Item { // Spacer
		width: 12
		height: parent.height
	}

	Button {
		text: "..."
		anchors.verticalCenter: parent.verticalCenter
		onClicked: function () {
			chooseFileDialog.show();
		}
	}

	Item { // Spacer
		width: 12
		height: parent.height
	}

	TextInput {
		id: chosenFileInput
		anchors.verticalCenter: parent.verticalCenter
	}

	ChooseFileDialog {
		id: chooseFileDialog
		nameFilters: "Image files (*.jpg *.png)"
		onChooseFile: function(url) {
			chosenFileInput.text = url;
		}
	}
}
