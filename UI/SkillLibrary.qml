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

	ScrollView {
		id: scrollView
		width: parent.width
		height: parent.height - skillLibraryTitle.height
		//clip: true // Breaks z-order
		contentHeight: skillLibraryList.childrenRect.height
		InteractiveListView {
			id: skillLibraryList
			width: parent.width
			highlightEnabled: false
			implicitHeight: childrenRect.height
			model: skillLibraryModel.listModel

			delegate: SkillInLibrary {
				container: skillLibraryList
			}
			footer: Item {
				id: footerItem
				Button {
					id: btnNew
					text: qsTr("New")
					onClicked: function() {
						skillCreationDialog.show();
					}
				}
				height: btnNew.height
			}
		}
	}
}
