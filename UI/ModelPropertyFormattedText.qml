import QtQuick
import QtQuick.Controls

Item {
	id: root

	property var model: null
	property string propId
	property var text: qsTr("Example text")
	property bool bold: false
	property alias textLabel: textLabel

	width: textLabel.width
	height: textLabel.height

	function textLogic() {
		if (root.model && root.propId)
		{
			if (root.model.hasOwn("frameImgPath"))
				return root.text;
			else if (root.model.has("frameImgPath"))
				return "<font color='#f58142'><i>"
						+ (root.bold ? "<b>" : "")
						+ root.text +
						+ (root.bold ? "</b>" : "")
						+ "</i></font>";
			return "<font color='#db0000'><i>"
					+ (root.bold ? "<b>" : "")
					+ root.text
					+ (root.bold ? "</b>" : "")
					+ "</i></font>";
		}
		else
			return text;
	}

	Text {
		id: textLabel
		text: textLogic
	}
}

