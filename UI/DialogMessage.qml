import QtQuick
import QtQuick.Controls

DialogTemplate {
	id: dialogTemplate
	title: ""

	property alias message: messageText.text

	Text {
		id: messageText
		anchors.fill: parent
		wrapMode: Text.WordWrap
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignHCenter
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
	}
}
