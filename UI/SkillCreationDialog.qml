import QtQuick
import QtQuick.Controls

SkillEditDialog {
	title: qsTr("New skill creation")

	QtObject {
		id: local
		property bool stored: false
		property var cell: null
	}

	property var show: function(protoModel, cell) {
		if (cell)
			local.cell = cell;
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
		if (local.cell)
		{
			logic.autoPlaceSkillOnField(model, local.cell, grid);
			local.cell = null;
		}
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
