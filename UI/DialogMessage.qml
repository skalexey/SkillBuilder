import QtQuick
import QtQuick.Controls

DialogTemplate {
	id: dialogTemplate
	title: ""

	property var show: function(title, message, onOk, onCancel) {
		this.title = title;
		this.message = message;
		if (onOk)
			this.onOk = onOk;
		if (onCancel)
			this.onCancel = onCancel;
		else
			oneBtn = true;
		dialogTemplate_show();
	}

	property alias message: messageText.text

	Text {
		id: messageText
		anchors.fill: bodyBlock
		wrapMode: Text.WordWrap
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
	}

	onClosed: function() {
		onOk = dialogTemplate_onOk
		onCancel = dialogTemplate_onCancel
		oneBtn = false;
	}
}
