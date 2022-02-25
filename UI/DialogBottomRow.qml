import QtQuick
import QtQuick.Controls

Item {
	id: bottomRow
	width: parent.width;
	height: cancelButton.height
	anchors.bottom: parent.bottom

	property var dialog

	state: "twoButtons"

	function stateOneButton() {
		state = "oneButton";
	}

	function stateTwoButtons() {
		state = "twoButtons";
	}

	Button {
		id: okButton
		visible: false
		text: buttonOkText
		width: parent.width / 2 - 20;
		onClicked: function(mouse) {
			var result = dialog.onOk();
			if (result === true || typeof result === "undefined")
				dialog.close();
		}
	}
	Button {
		id: cancelButton
		visible: false
		text: buttonCancelText
		width: parent.width / 2 - 20;
		onClicked: function(mouse) {
			dialog.onCancel();
			dialog.close();
		}
	}
	states: [
		State {
			name: "oneButton"

			PropertyChanges {
				target: okButton
				visible: true
				anchors.leftMargin: parent.width / 2 - okButton.width / 2
			}
		},
		State {
			name: "twoButtons"
			PropertyChanges {
				target: cancelButton
				visible: true
				anchors.right: parent.right
			}

			PropertyChanges {
				target: okButton
				visible: true
				anchors.left: parent.left
			}
		}
	]
}
