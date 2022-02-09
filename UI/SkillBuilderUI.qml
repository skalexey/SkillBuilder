import QtQuick
import SkillBuilderUI 1.0
import QtQuick.Controls
import QtQuick.Window

Item {
	width: Constants.width
	height: Constants.height

	Screen01 {
		Rectangle {
			id: topBlock
			width: parent.width
			height: 60
			Button {
				id: btnStore
				x: 14
				text: qsTr("Store")
				anchors.verticalCenter: parent.verticalCenter
				onClicked: storeClicked()
			}
			Button {
				id: btnFile
				x: 14
				text: qsTr("File")
				anchors.verticalCenter: parent.verticalCenter
				onClicked: fileMenu.popup()
			}
			Text {
				x: btnFile.x + btnFile.width + 12
				anchors.verticalCenter: parent.verticalCenter
				text: textCurrentFile
			}

			Menu {
				id: fileMenu
				MenuItem {
					text: "Open"
					onClicked: openFileClicked()
				}
				MenuItem {
					text: "Save"
					onClicked: saveClicked()
				}
				MenuItem {
					text: "Save as"
					onClicked: saveAsClicked()
				}
			}
		}

		BodyBlock {
			id: bodyBlock
		}
	}

}
