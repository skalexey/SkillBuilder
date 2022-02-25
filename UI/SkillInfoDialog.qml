import QtQuick
import QtQuick.Controls

DialogTemplate {
	id: dialog
	title: qsTr("Skill info")
	height: 400

	property alias name: name
	property alias iconPath: iconPath
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

	show: function(skillModel) {
		model = skillModel;
		oneBtn = true;
		dialogTemplate_show();
	}

	onClosed: function() {
		model = null;
	}

	onShow: function() {
		dialogTemplate_onShow();
	}

	onOk: function() {
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

		TextLineRow {
			id: name
			title: qsTr("Name")
			value: getName()
		}

		Item {
			width: parent.width
			height: 12
		}

		ImageRow {
			id: icon
			title: qsTr("Icon")
			source: model ? model.get("iconPath").value : ""
			height: 100
		}

		TextLineRow {
			id: iconPath
			title: qsTr("Icon path")
			tooltip: true
			value: model ? model.get("iconPath").value : ""
		}

		Item {
			width: parent.width
			height: 12
		}

		Column {
			width: parent.width
			Text {
				id: descriptionLabel
				text: qsTr("Description")
			}

			Text {
				id: textValue
				width: dialog.width
				clip: true
				wrapMode: Text.Wrap
				text: model ? model.get("description").value : ""
			}
		}
	}
}
