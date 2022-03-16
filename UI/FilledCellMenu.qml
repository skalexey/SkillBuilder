import QtQuick
import QtQuick.Controls

Menu {
	id: contextMenu
	property alias detachMenuItem: detachMenuItem

	CustomMenuItem {
		text: "Info"
		onClicked: showInfo()
	}
	CellAddSubMenu {

	}

	NewSkillOnFieldMenuItem {

	}

	CustomMenuItem {
		id: detachMenuItem
		text: "Detach from parent"
		onClicked: detachFromParent()
		visible: logic.hasParentSkill(attachedSkill)
		height: visible ? implicitHeight : 0
	}

	CustomMenuItem {
		text: "Remove"
		onClicked: removeCell()
	}
}
