import QtQuick
import QtQuick.Window
import QVL 1.0
import SkillBuilderUI 1.0

Window {
	id: root
	width: Constants.width
	height: Constants.height
	visible: true
	title: qsTr("SkillBuilder")

	SkillBuilderUI {
		id: uiRoot
		width: root.width
		height: root.height
	}
}
