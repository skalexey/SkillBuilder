import QtQuick
import QtQuick.Controls

Menu {
	id: addMenu
	title: "Add"
	Instantiator {
		model: skillLibraryModel.listModel
		onObjectAdded: function(i, o) {
			addMenu.insertItem(i, o);
		}
		onObjectRemoved: function(o) {
			addMenu.removeItem(o);
		}
		delegate: MenuItem {
			text: value.get("name").value
			onTriggered: function() {
				logic.autoPlaceSkillOnField(value, root, grid);
			}
		}
	}
}
