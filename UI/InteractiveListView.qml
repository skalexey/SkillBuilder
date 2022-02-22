import QtQuick
import QtQuick.Controls

ListView {
	id: container
	property bool highlightEnabled: true
	highlight: Rectangle {
		property var currentItem: container.currentItem
		color: "#7600b9ff"
		width: parent ? parent.width : 0
		height: currentItem ? currentItem.height : 0
		y: currentItem ? currentItem.y : 0
		visible: highlightEnabled
	}
	highlightFollowsCurrentItem: false
}
