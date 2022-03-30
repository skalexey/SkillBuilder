import QtQuick
import SkillBuilderUI 1.0
import QtQuick.Controls
import QtQuick.Window
import QVL 1.0
import SkillBuilderUI
import "logic.js" as Logic
import "compactPlacingStrategy.js" as PlacingStrategy

// Uncomment this to test dialogs in Qt Design Studio
// And comment out the following "Item {" declaration
// Window {
Item {
	id: root
	width: Constants.width
	height: Constants.height
	// Uncomment this to test dialogs in Qt Design Studio
	//visible: true
	//title: "SkillBuilder"

	property var logic: Logic
	property var placingStrategy: PlacingStrategy
	property alias grid: bodyBlock.grid
	property alias bodyBlock: bodyBlock
	property var skillLibraryModel: null
	property var rootSkillModel: null

	QtObject {
		id: local
		property string databasePath: "../../resources/database.json"
		property bool loadError: false;
		property var modelLoadError: function(error) {
			if (!local.loadError)
			{
				local.loadError = true;
				dmbModel.store(databasePath);
				dmbModel.load(databasePath);
			}
			else
				uiRoot.modelLoadError(e);
		}
		property var modelLoaded: function(f) {
			console.log("Database loaded from '" + f + "'");
			skillLibraryModel = dmbModel.contentModel.get("skillLibrary");
			rootSkillModel = dmbModel.contentModel.get("rootSkill");
		}
	}

	property var modelLoadError: function(e) {
		bodyBlock.stateLoadDatabaseError();
	}

	property var dmbModel: DMBModel {
		loadFrom: local.databasePath
		onModelLoaded:  function(f) {
			console.log("Database loaded from '" + dmbModel.currentFile + "'");
			local.modelLoaded(f);
		}
		onModelLoadError: function(f, e) {
			console.log("Database load error: '" + e + "'");
			local.modelLoadError(f, e);
		}
	}

	Component.onCompleted: {
		if (!dmbModel.isLoaded)
			local.modelLoadError();
		//else
			//bodyBlock.stateLoaded();
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

	SkillEditDialog {
		id: skillEditDialog
	}

	DialogMessage {
		id: messageDialog
	}
}
