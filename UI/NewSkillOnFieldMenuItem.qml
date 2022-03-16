import QtQuick
import QtQuick.Controls

MenuItem {
	text: "New"
	onTriggered: function() {
		skillCreationDialog.show(null, root);
	}
}
