import QtQuick
import QtQuick.Controls

DialogTemplate {
	title: qsTr("New skill creation")
	height: 400
	onShow: function() {
		name.textInput.forceActiveFocus();
	}

	onOk: function() {

	}

	Column {
		height: parent.height
		width: parent.width

		TextInputRow {
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
	}
}
