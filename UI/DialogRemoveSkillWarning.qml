import QtQuick
import QtQuick.Controls

DialogMessage {
	title: qsTr("Warning!")
	message: qsTr("This skill has instances in the field. Do you really want to remove it with all it's instances?");

	property var skillModel: null;

	show: function(aSkillModel) {
		skillModel = aSkillModel;
		message = qsTr("Skill '" + skillModel.get("name").value + "' has instances in the field. Do you really want to remove it with all it's instances?");
		dialogTemplate_show();
	}
	onOk: function() {
		console.log("removeAllSkillsOfType");
		logic.removeAllSkillsOfType(skillModel, rootSkillModel());
		console.log("skillModel.remove();")
		skillModel.remove();
		dmbModel.store();
		return true;
	}
}
