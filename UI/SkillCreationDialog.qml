import QtQuick
import QtQuick.Controls

SkillEditDialog {
	title: qsTr("New skill creation")

	QtObject {
		id: local
		property bool stored: false
	}

	property var show: function(protoModel) {
		var o = dmbModel.createObject();
		o.setPrototype(protoModel ? protoModel : "Skill");
		// The model is assigned o in the parent function call
		skillEditDialog_show(o);
	}

	onOk: function() {
		if (name.enteredText !== "")
			model.set("name", name.enteredText);
		model.set("iconPath", iconPath.chosenFilePath);
		model.set("description", description.enteredText);
		skillLibraryModel.add(model);
		dmbModel.store();
		local.stored = true;
		return true;
	}

	onClosed: function() {
		if (!local.stored)
			model.remove();
		model = null;
	}
}
