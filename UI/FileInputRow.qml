import QtQuick
import QtQuick.Controls

Row {
	id: row
	width: parent.width

	property var chosenFile
	property string title: qsTr("Row")
	property alias chosenFilePath: chosenFileInput.text
	property var onChooseFile

	Text {
		id: textLabel
		text: title
		anchors.verticalCenter: parent.verticalCenter
	}

	Item { // Spacer
		id: spacer1
		width: 12
		height: parent.height
	}

	Button {
		id: btn
		text: "..."
		anchors.verticalCenter: parent.verticalCenter
		onClicked: function () {
			chooseFileDialog.show();
		}
	}

	Item { // Spacer
		id: spacer2
		width: 12
		height: parent.height
	}

	TextField {
		id: chosenFileInput
		anchors.verticalCenter: parent.verticalCenter
		width: parent.width - textLabel.width - spacer1.width - btn.width - spacer2.width
	}

	ChooseFileDialog {
		id: chooseFileDialog
		nameFilters: "Image files (*.jpg *.png)"
		onChooseFile: function(url) {
			chosenFileInput.text = url;
			if (row.onChooseFile)
				row.onChooseFile(url);
		}
	}
}
