var createdSkill = null;
var draggableItem = null;

function log(msg) {
	console.log("Logic: " + msg);
}

function isAParentOf(item1, item2) {
	var item1ChildrenContainer = item1.model.get("children");
	var p = item2.model.parent;
	while (p)
	{
		if (p === item1ChildrenContainer)
			return true;
		p = p.parent;
	}
	return false;
}

function isAChildOf(item1, item2) {
	var item2ChildrenContainer = item2.model.get("children");
	var p = item1.model.parent;
	while (p)
	{
		if (p === item2ChildrenContainer)
			return true;
		p = p.parent;
	}
	return false;
}

function getAttachedSkillParentItem(skillItem, grid) {
	function getCell(x, y) {
		var index = getCellIndex(x, y);
		return grid.children[index];
	}
	var parentContainer = skillItem.model.parent;
	if (!parentContainer)
		return null;
	var parentSkillModel = parentContainer.parent;
	if (!parentSkillModel)
		return null;
	var xModel = parentSkillModel.get("x");
	if (!xModel)
		return null;
	var x = xModel.value;
	var y = parentSkillModel.get("y").value;
	return getCell(x, y).attachedSkill;
}



function setInterval(f, d) {
	function Timer() {
		return Qt.createQmlObject("import QtQuick; Timer {}", root);
	}

	var timer = new Timer();
	timer.interval = d;
	timer.repeat = true;
	timer.triggered.connect(f);

	timer.start();
	return timer;
}

function clearInterval(timer) {
	timer.stop();
}

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
		log("Error! Funcion removeAllSkillsOfType can't iterate children of a skill '" + rootSkillModel.get("name").value
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
		log("Error! Funcion hasSkill can't iterate children of a skill '" + rootSkillModel.get("name").value
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

function placeSkillsOnField(grid, rootSkillModel) {
	var rootSkill = rootSkillModel;
	if (rootSkill)
	{
		var rootSkillList = rootSkill.get("children");
		if (rootSkillList)
		{
			var listModel = rootSkillList.listModel;
			var sz = listModel.rowCount();
			log(sz + " skills in the tree");
			for (var i = 0; i < sz; i++)
			{
				var m = listModel.at(i);
				log("Iterate skill in the tree: '" + m.get("name").value + "' at position " + m.get("x").value + ", " + m.get("y").value);
				logic.placeSkill(grid, m);
				logic.placeSkillsOnField(grid, m);
			}
		}
		else
		{
			log("Error! There is no 'children' field in the rootSkill node");
		}
	}
	else
	{
		log("Error! There is no skill tree (rootSkill) in the content");
	}
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
		createSkillWithModel(model, cell, function(createdSkill) {
			log("Skill at position (" + x + ", " + y + ") created");
			cell.attachedSkill = createdSkill;
			createdSkill.origin = "field";
			model.beforeRemove.connect(function() {
				createdSkill.destroy();
			});
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
//		log("Create component PropListBlock.qml");
		c = Qt.createComponent("Skill.qml");
		if (c.status === Component.Ready)
			finishCreation(from, parent, onCreated);
		else
		{
//			log("Creation is not ready yet. Wait")
			c.statusChanged.connect(function() {
				finishCreation(from, parent, onCreated);
			});
		}
	}
	function finishCreation(from, parent, onCreated) {
//		log("finish creation")
		if (c.status === Component.Ready)
		{
			//log("finishCreation");
			createdSkill = c.createObject(parent, {
				model: from.model
			});
			if (onCreated)
				onCreated(createdSkill);
		}
		else if (c.status === Component.Error)
			// Error Handling
			log("Error loading component:", c.errorString());
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
