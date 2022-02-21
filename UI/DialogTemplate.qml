import QtQuick
import QtQuick.Controls

Dialog {
	id: dialog
	title: qsTr("Title")
	property var onShow: function() {}
	property var show: function() {
		visible = true;
		onShow();
	}
	property string buttonOkText: qsTr("Ok")
	property string buttonCancelText: qsTr("Cancel")
	property var onOk: function() {
		console.log("DialogTemplate.onOk default handler");
	}
	property var onCancel: function() {
		console.log("DialogTemplate.onCancel default handler");
	}

	onClosed: function() {
		console.log("DialogTemplate.onClosed default handler");
	}

	modal: true
	x: parent.width / 2 - width / 2
	y: parent.height / 2 - height / 2
	width: 300
	height: 220

	Item {
		id: row
		width: parent.width;
		height: cancelButton.height
		anchors.bottom: parent.bottom
		Button {
			id: okButton
			text: buttonOkText
			width: parent.width / 2 - 20;
			anchors.left: parent.left
			onClicked: function(mouse) {
				onOk();
				dialog.close();
			}
		}
		Button {
			id: cancelButton
			text: buttonCancelText
			anchors.right: parent.right
			width: parent.width / 2 - 20;
			onClicked: function(mouse) {
				onCancel();
				dialog.close();
			}
		}
	}
}

/*##^##
Designer {
	D{i:0;formeditorZoom:0.9}D{i:2}D{i:3}D{i:1}
}
##^##*/
