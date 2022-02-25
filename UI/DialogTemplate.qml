import QtQuick
import QtQuick.Controls

Dialog {
	id: dialogTemplate
	title: qsTr("Title")

	property bool oneBtn: false

	property alias bodyBlock: bodyBlock

	property var dialogTemplate_onShow: function() {

	}
	property var dialogTemplate_show: function() {
		if (oneBtn)
			bottomRow.stateOneButton();
		else
			bottomRow.stateTwoButtons();
		visible = true;
		if (onShow)
			onShow();
	}
	property var onShow: dialogTemplate_onShow
	property var show: dialogTemplate_show
	property string buttonOkText: qsTr("Ok")
	property string buttonCancelText: qsTr("Cancel")
	property var dialogTemplate_onOk: function() {
		//console.log("dialogTemplate_onOk default handler");
		return true;
	}

	property var dialogTemplate_onCancel: function() {
		//console.log("dialogTemplate_onCancel default handler");
	}

	property var dialogTemplate_onClosed: function() {
		//console.log("dialogTemplate_onClosed default handler");
	}

	property var onOk: dialogTemplate_onOk
	property var onCancel: dialogTemplate_onCancel
	onClosed: dialogTemplate_onClosed

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

	DialogBottomRow {
		id: bottomRow
		dialog: dialogTemplate
	}
}

/*##^##
Designer {
	D{i:0;formeditorZoom:0.9}D{i:2}D{i:3}D{i:1}
}
##^##*/
