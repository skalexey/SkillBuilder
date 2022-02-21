import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

FileDialog {
	property var show: function() {
		visible = true;
	}
	property var onChooseFile: function() {
		console.log("ChooseFileDialog: onChooseFile default handler");
	}

	id: fd
	title: "Choose a file"
	nameFilters: "*.json"
	onAccepted: function() {
		onChooseFile(fd.currentFile);
	}
	onRejected: {
	}
}
