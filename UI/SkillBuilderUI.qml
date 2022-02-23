import QtQuick
import SkillBuilderUI 1.0
import QtQuick.Controls
import QtQuick.Window
import QVL 1.0
import "logic.js" as Logic

Item {
	id: root
	width: Constants.width
	height: Constants.height
//	visible: true
//	title: "SkillBuilder"

	property var logic: Logic
	property alias bodyBlock: bodyBlock
	property var skillLibraryModel: dmbModel.contentModel.get("skillLibrary")
	property var rootSkillModel: function() {
		return dmbModel.contentModel.get("rootSkill");
	}
	property var dmbModel: DMBModel {
		loadFrom: "designer-database.json"
		onModelLoaded: function(f) {
			console.log("Database loaded from '" + currentFile + "'");
		}
		onModelLoadError: function(f, e) {
			console.log("Database load error: '" + e + "'");
		}
	}

	property var onNewSkillClicked: function() {
		skillCreationDialog.show();
	}

	Screen01 {
		Rectangle {
			id: topBlock
			width: parent.width
			height: 60

			Button {
				id: btnFile
				x: 14
				text: qsTr("File")
				anchors.verticalCenter: parent.verticalCenter
				onClicked: fileMenu.popup()
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

	SkillCreationDialog {
		id: skillCreationDialog
	}

	SkillInfoDialog {
		id: skillInfoDialog
	}

	DialogRemoveSkillWarning {
		id: dialogRemoveSkillWarning
	}
}
