import QtQuick
import QtQuick.Controls

DialogTemplate {
	id: dialog

	title: qsTr("Skill info")
	height: 600

	property alias name: name
	property alias iconPath: iconPath
	property alias description: description
	property var model: null

	QtObject {
		id: local
		property var baseShow: show;
		property var inputModel: null
	}

	function log(msg) {
		console.log("SkillEditDialog: " + msg);
	}

	function getName() {
		return model ? model.get("name").value : "";
	}

	function getProtoName() {
		return model ? model.get("proto").get("name").value : "";
	}

	property var skillEditDialog_show: function(skillModel) {
		if (skillModel)
		{
			local.inputModel = skillModel;
			model = local.inputModel.copy();
			log("skillEditDialog_show: model: " + model);
			dialogTemplate_show();
			name.textInput.forceActiveFocus();
		}
	}

	show: skillEditDialog_show

	property var skillEditDialog_onClosed: function() {
		if (model)
		{
			model.remove();
			model = null;
		}
		local.inputModel = null
	}

	onClosed: skillEditDialog_onClosed

	onShow: function() {
		dialogTemplate_onShow();
		if (model) {
			name.enteredText = model.get("name").value
			iconPath.chosenFilePath = model.get("iconPath").value
			description.enteredText = model.get("description").value
		}
		border.recalculate();
	}

	onOk: function() {
		if (local.inputModel) {
			if (name.enteredText !== local.inputModel.get("name").value)
				local.inputModel.set("name", name.enteredText);
			if (iconPath.chosenFilePath !== local.inputModel.get("iconPath").value)
				local.inputModel.set("iconPath", iconPath.chosenFilePath);
			var tmpFrameImgPath = model.getOwn("frameImgPath");
			if (tmpFrameImgPath && local.inputModel.get("frameImgPath").value !== tmpFrameImgPath.value)
				local.inputModel.set("frameImgPath", tmpFrameImgPath.value);
			else if (!tmpFrameImgPath && local.inputModel.hasOwn("frameImgPath"))
				local.inputModel.removeProp("frameImgPath");
			if (description.enteredText !== local.inputModel.get("description").value)
			local.inputModel.set("description", description.enteredText);
			dmbModel.store();
		}
		return true;
	}

	Column {
		id : content

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

		FileInputRow {
			id: borderPath
			title: qsTr("Border icon path")
			onChooseFile: function(url) {
				dialog.model.set("frameImgPath", url);
//				resetBtn.visible = Qt.binding(function() {return
//					dialog.model ? dialog.model.hasOwn("frameImgPath") : false;
//				});
			}
		}
		ImageRow {
			id: border
			property alias resetBtn: resetBtn
			textLabelComponent: Component {
					ModelPropertyFormattedTextWithHint {
					model: dialog.model
					propId: "frameImgPath"
					text: "Border"
				}
			}
			source: model ? model.get("frameImgPath").value : ""
			height: 100
			Button {
				id: resetBtn
				text: qsTr("Reset")
				onClicked: function() {
					if (dialog.model)
						dialog.model.removeProp("frameImgPath");
				}
				visible: dialog.model ? dialog.model.hasOwn("frameImgPath") : false
			}
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
