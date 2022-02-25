import QtQuick
import QtQuick.Controls

Column {
	id: leftBlock
	width: parent.width
	height: parent.height

	Text {
		id: skillLibraryTitle
		text: "Skill library"
		anchors.horizontalCenter: parent.horizontalCenter
	}

	InteractiveListView {
		id: skillLibraryList
		width: parent.width
		highlightEnabled: false
		implicitHeight: contentItem.childrenRect.height
		model: skillLibraryModel.listModel

		delegate: SkillInLibrary {
			container: skillLibraryList
		}
		footer: Item {
			Button {
				text: qsTr("New")
				onClicked: function() {
					skillCreationDialog.show();
				}
			}
		}
	}
}
