var createdSkill = null;
var draggableItem = null;

function getCoord(cellIndex) {
	return {"x": cellIndex % Constants.fieldSize,
			"y": parseInt(cellIndex / Constants.fieldSize) };
}

function getCellIndex(x, y) {
	return y * Constants.fieldSize + x;
}

function placeSkill(grid, model, item) {
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
			console.log("Skill at position " + pos + " created");
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
