import QtQuick
import QtQuick.Controls

Column {
	id: root

	property var model: null
	property string propId
	property var text: qsTr("Example text")

	width: Math.max(text1.width, text2.width)
	height: text1.height + text2.height

	ModelPropertyFormattedText {
		id: text1
		text: root.text
		model: root.model
		propId: root.propId
	}

	ModelPropertyFormattedText {
		id: text2
		text: {
			if (!root.model)
				return "<<null>>";
			if (!root.model.has("frameImgPath"))
				return qsTr("Not present");
			else if (!root.model.hasOwn("frameImgPath"))
				return qsTr("Inherited");
			else
				return "";
		}
		model: root.model
		propId: model.propId
		bold: true
	}
}

