import QtQuick
import QtQuick.Controls

MenuItem {
	QtObject {
		id: local
		property int height: -1
	}

	function hide() {
		local.height = height;
		height = 0;
		visible = false;
	}

	function show() {
		height = local.height;
		visible = true;
	}
}
