var createdSkill = null;
var draggableItem = null;

function removeAllSkillsOfType(skillModel, rootSkillModel) {
	var skillName = skillModel.get("name").value
	var children = rootSkillModel.get("children")
	var l = [];
	if (children)
	{
		var listModel = rootSkillModel.get("children").listModel;
		var sz = listModel.rowCount();
		for (var i = 0; i < sz; i++)
		{
			var m = listModel.at(i);
			if (m.get("name").value === skillName)
				l.push(m);
			removeAllSkillsOfType(skillModel, m);
		}
	}
	else
	{
		console.log("Error! Funcion removeAllSkillsOfType can't iterate children of a skill '" + rootSkillModel.get("name").value
					+ "' of type '" + rootSkillModel.typeId
					+ "' and with proto '" + rootSkillModel.protoId
		+ "'");
	}
	for (var i = 0; i < l.length; i++)
		l[i].remove();
	return false;
}

function hasSkill(skillModel, rootSkillModel) {
	var skillName = skillModel.get("name").value
	var children = rootSkillModel.get("children")
	if (children)
	{
		var listModel = rootSkillModel.get("children").listModel;
		var sz = listModel.rowCount();
		for (var i = 0; i < sz; i++)
		{
			var m = listModel.at(i);
			if (m.get("name").value === skillName)
				return true;
			if (hasSkill(skillModel, m))
				return true;
		}
	}
	else
	{
		console.log("Error! Funcion hasSkill can't iterate children of a skill '" + rootSkillModel.get("name").value
					+ "' of type '" + rootSkillModel.typeId
					+ "' and with proto '" + rootSkillModel.protoId
		+ "'");
	}

	return false;
}

function getCoord(cellIndex) {
	return {"x": cellIndex % Constants.fieldSize,
			"y": parseInt(cellIndex / Constants.fieldSize) };
}

function getCellIndex(x, y) {
	return y * Constants.fieldSize + x;
}

function placeSkill(grid, model, itemOrOnCreated) {
	var item = null;
	var onCreated = null;
	if (typeof itemOrOnCreated === "object")
		item = itemOrOnCreated;
	else if (typeof itemOrOnCreated === "function")
		onCreated = itemOrOnCreated;
	var x = model.get("x").value;
	var y = model.get("y").value;
	var pos = getCellIndex(x, y);
	var cell = grid.children[pos];
	if (item)
	{
		item.parent = cell
		item.x = 0;
		item.y = 0;
	}
	else
	{
		Logic.createSkillWithModel(model, cell, function(createdSkill) {
			console.log("Skill at position (" + x + ", " + y + ") created");
			cell.attachedSkill = createdSkill;
			createdSkill.origin = "field";
			if (onCreated)
				onCreated(createdSkill);
		});
	}
}

function createSkillWithModel(model, parent, onCreated) {
	var from = {model: model};
	createSkill(from, parent, onCreated);
}

function createSkill(from, parent, onCreated) {
	var c = null;
	function create() {
//		console.log("Create component PropListBlock.qml");
		c = Qt.createComponent("Skill.qml");
		if (c.status === Component.Ready)
			finishCreation(from, parent, onCreated);
		else
		{
//			console.log("Creation is not ready yet. Wait")
			c.statusChanged.connect(function() {
				finishCreation(from, parent, onCreated);
			});
		}
	}
	function finishCreation(from, parent, onCreated) {
//		console.log("finish creation")
		if (c.status === Component.Ready)
		{
			//console.log("finishCreation");
			createdSkill = c.createObject(parent, {
				model: from.model
			});
			if (onCreated)
				onCreated(createdSkill);
		}
		else if (c.status === Component.Error)
			// Error Handling
			console.log("Error loading component:", c.errorString());
	}
	create();
}

function initDrag(item, dragHandler) {
	draggableItem = item;
	if (dragHandler)
		dragHandler.target = draggableItem;
	draggableItem.startDrag(dragHandler);
}

function stopDrag(dragHandler) {
	if (draggableItem)
	{
		// Stop the drag before destoying
		draggableItem.stopDrag();
	}
	if (dragHandler)
		dragHandler.target = null;
}

function destroyDraggableItem(dragHandler) {
	if (draggableItem)
	{
		// Stop the drag before destoying
		draggableItem.stopDrag();
		draggableItem.destroy();
		draggableItem = null;
		if (dragHandler)
			dragHandler.target = null;
	}
}
