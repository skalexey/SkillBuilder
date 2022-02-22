import QtQuick
import QtQuick.Controls

SkillInfoDialog {
	title: qsTr("New skill creation")
	height: 400

	onOk: function() {
		var o = dmbModel.createObject();
		o.setPrototype("Skill");
		o.set("name", name.enteredText);
		o.set("iconPath", iconPath.chosenFilePath);
		o.set("description", description.enteredText);
		skillLibraryModel.add(o);
		dmbModel.store();
		return true;
	}
}
