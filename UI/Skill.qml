import QtQuick
import QtQuick.Controls

Row {
	property var model
	width: parent.width
	height: 80
	BorderImage {
		id: borderImage
		width: 60
		height: 60
		source: model.get("frameImgPath").value
	}

	Text {
		text: model.get("name").value
	}
}
