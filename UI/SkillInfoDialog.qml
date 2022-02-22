import QtQuick
import QtQuick.Controls

DialogTemplate {
	title: qsTr("Skill info")
	height: 400

	property alias name: name
	property alias iconPath: iconPath
	property alias description: description
	property var model: null

	QtObject {
		id: local
		property var baseShow: show;
	}

	show: function(skillModel) {
		name.textInput.forceActiveFocus();
		model = skillModel;
		dialogTemplate_show();
	}

	onClosed: function() {
		model = null;
	}

	onShow: function() {
		dialogTemplate_onShow();
		if (model) {
			name.enteredText = model.get("name").value
			iconPath.chosenFilePath = model.get("iconPath").value
			description.enteredText = model.get("description").value
		}
	}

	onOk: function() {
		if (model) {
			model.set("name", name.enteredText);
			model.set("iconPath", iconPath.chosenFilePath);
			model.set("description", description.enteredText);
			dmbModel.store();
		}
		return true;
	}

	Column {
		height: parent.height
		width: parent.width

		LineInputRow {
			id: name
			title: "Name"
		}

		Item {
			width: parent.width
			height: 12
		}

		FileInputRow {
			id: iconPath
			title: "Icon"
		}

		Item {
			width: parent.width
			height: 12
		}

		TextInputRow {
			id: description
			title: "Description"
			placeholderText: "Enter description"
		}

	}
}
