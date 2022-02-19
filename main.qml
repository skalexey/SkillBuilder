import QtQuick
import QtQuick.Window
import QVL 1.0
import SkillBuilderUI 1.0

Window {
	id: root
	width: Constants.width
	height: Constants.height
	visible: true
	title: qsTr("Hello World")

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
		}
	}

	SkillBuilderUI {
		id: uiRoot
		width: root.width
		height: root.height

		property var modelLoadError: function(e) {
			bodyBlock.stateLoadDatabaseError();
		}

		dmbModel: DMBModel {
			loadFrom: local.databasePath
			onModelLoaded: function(f) {
				console.log("Database loaded from '" + currentFile + "'");
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
	}
}
