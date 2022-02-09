import QtQuick
import QtQuick.Window
import QVL 1.0
import SkillBuilderUI 1.0

Window {
	width: Constants.width
	height: Constants.height
	visible: true
	title: qsTr("Hello World")

	QtObject {
		id: local
		property bool loadError: false;
	}

	DMBModel {
		id: dmbModel
		loadFrom: "database.json"
		onInstantiateRefused: function(error) {
			console.log("Instantiate refused: " + error);
		}
		onModelLoaded: function(f) {
			uiRoot.onModelLoaded(f);
		}
		onModelLoadError: function(e) {
			if (!local.loadError)
			{
				local.loadError = true;
				dmbModel.store(fPath);
				dmbModel.load(fPath);
			}
			else
				uiRoot.onModelLoadError(e);
		}
	}

	SkillBuilderUI {
		id: uiRoot
		width: root.width
		height: root.height
		property var onModelLoadError: function(error) {
			console.log("Load database error: " + error);
		}
		Component.onCompleted: {
			if (!dmbModel.isLoaded)
				bodyBlock.stateLoadDatabaseError();
			//else
				//bodyBlock.stateLoaded();
		}
	}
}
