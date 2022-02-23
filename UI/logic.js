console.log("Import logic.js");

var createdSkill = null;
var draggableItem = null;
var suggestedPlaces = [];
var hidePlaceSuggestionsInterval = null;
var suggestedPlaceUsers = [];

function placeSuggestionsActive() {
	return suggestedPlaces.length > 0;
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

function isTheOnlySuggestionsUser(cell) {
	return suggestedPlaceUsers.length == 1
			&& suggestedPlaceUsers.indexOf(cell) >= 0;
}

function addSuggestionsUser(user) {
	suggestedPlaceUsers.push(user);
	if (hidePlaceSuggestionsInterval)
	{
		clearInterval(hidePlaceSuggestionsInterval);
		hidePlaceSuggestionsInterval = null;
	}
}

function removeSuggestionsUser(user) {
	var index = suggestedPlaceUsers.indexOf(user);
	if (index >= 0)
		suggestedPlaceUsers.splice(index, 1);
}

function isSuggestedCell(cell) {
	return suggestedPlaces.indexOf(cell) >= 0;
}

function showPlaceSuggestions(grid, cell) {
	if (suggestedPlaces.length > 0)
		hidePlaceSuggestions();

	addSuggestionsUser(cell);

	function checkAndPushCell(x, y) {
		var index = getCellIndex(x, y);
		var c = grid.children[index];
		if (!c.attachedSkill)
		{
			suggestedPlaces.push(c);
			c.state = "suggested";
		}
	}

	var x = cell.attachedSkill.model.get("x").value;
	var y = cell.attachedSkill.model.get("y").value;
	var index = getCellIndex(x, y);

	if (x > 0 && x < Constants.fieldSize)
		checkAndPushCell(x - 1, y); // Left
	if (x >= 0 && x < (Constants.fieldSize - 1))
		checkAndPushCell(x + 1, y); // Right
	if (y > 0 && y < Constants.fieldSize)
		checkAndPushCell(x, y - 1); // Top
	if (y >= 0 && y < (Constants.fieldSize - 1))
		checkAndPushCell(x, y + 1); // bottom
}

function hidePlaceSuggestions(delayed) {
	function job() {
		if (hidePlaceSuggestionsInterval)
		{
			clearInterval(hidePlaceSuggestionsInterval);
			hidePlaceSuggestionsInterval = null;
		}

		for (var i = 0; i < suggestedPlaces.length; i++)
			suggestedPlaces[i].state = "base";
		suggestedPlaces = [];
		suggestedPlaceUsers = [];
	}

	if (delayed)
		hidePlaceSuggestionsInterval = setInterval(job, 1);
	else
		job();
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
		createSkillWithModel(model, cell, function(createdSkill) {
			console.log("Skill at position (" + x + ", " + y + ") created");
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
