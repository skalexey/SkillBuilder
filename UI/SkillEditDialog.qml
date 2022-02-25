import QtQuick
import QtQuick.Controls

DialogTemplate {
	id: dialog

	title: qsTr("Skill info")
	height: 500

	property alias name: name
	property alias iconPath: iconPath
	property alias description: description
	property var model: null

	QtObject {
		id: local
		property var baseShow: show;
	}

	function getName() {
		return model ? model.get("name").value : "";
	}

	function getProtoName() {
		return model ? model.get("proto").get("name").value : "";
	}

	property var skillEditDialog_show: function(skillModel) {
		model = skillModel;
		dialogTemplate_show();
		name.textInput.forceActiveFocus();
	}

	show: skillEditDialog_show

	property var skillEditDialog_onClosed: function() {
		model = null;
	}

	onClosed: skillEditDialog_onClosed

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

		Column {
			id: protoRow
			width: parent.width
			visible: getName() !== getProtoName()

			TextLineRow {
				id: proto
				title: qsTr("Proto")
				value: getProtoName()
			}

			Item {
				width: parent.width
				height: 12
			}
		}

		LineInputRow {
			id: name
			title: qsTr("Name")
		}

		Item {
			width: parent.width
			height: 12
		}

		FileInputRow {
			id: iconPath
			title: qsTr("Icon path")
			onChooseFile: function(url) {
				dialog.model.set("iconPath", url);
			}
		}
		ImageRow {
			id: icon
			title: qsTr("Icon")
			source: model ? model.get("iconPath").value : ""
			height: 100
		}

		Item {
			width: parent.width
			height: 12
		}

		TextInputRow {
			id: description
			title: qsTr("Description")
			//placeholderText: qsTr("Enter description")
		}

	}
}
