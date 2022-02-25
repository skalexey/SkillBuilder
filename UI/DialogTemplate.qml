import QtQuick
import QtQuick.Controls

Dialog {
	id: dialogTemplate
	title: qsTr("Title")

	property alias bodyBlock: bodyBlock

	property var dialogTemplate_onShow: function() {

	}
	property var dialogTemplate_show: function() {
		visible = true;
		if (onShow)
			onShow();
	}
	property var onShow: dialogTemplate_onShow
	property var show: dialogTemplate_show
	property string buttonOkText: qsTr("Ok")
	property string buttonCancelText: qsTr("Cancel")
	property var dialogTemplate_onOk: function() {
		//console.log("DialogTemplate.onOk default handler");
		return true;
	}

	property var dialogTemplate_onCancel: function() {
		//console.log("DialogTemplate.onCancel default handler");
	}

	property var onOk: dialogTemplate_onOk
	property var onCancel: dialogTemplate_onCancel

	onClosed: function() {
		//console.log("DialogTemplate.onClosed default handler");
	}

	modal: true
	x: parent.width / 2 - width / 2
	y: parent.height / 2 - height / 2
	width: 300
	height: 220

	Item {
		id: bodyBlock
		width: parent.width
		height: parent.height - bottomRow.height
	}

	Item {
		id: bottomRow
		width: parent.width;
		height: cancelButton.height
		anchors.bottom: parent.bottom
		Button {
			id: okButton
			text: buttonOkText
			width: parent.width / 2 - 20;
			anchors.left: parent.left
			onClicked: function(mouse) {
				var result = onOk();
				if (result === true || typeof result === "undefined")
					dialogTemplate.close();
			}
		}
		Button {
			id: cancelButton
			text: buttonCancelText
			anchors.right: parent.right
			width: parent.width / 2 - 20;
			onClicked: function(mouse) {
				dialogTemplate.onCancel();
				dialogTemplate.close();
			}
		}
	}
}

/*##^##
Designer {
	D{i:0;formeditorZoom:0.9}D{i:2}D{i:3}D{i:1}
}
##^##*/
