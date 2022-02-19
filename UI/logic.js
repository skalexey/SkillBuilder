var createdSkill = null;
var draggableItem = null;

function placeSkill(grid, model) {
	var pos = model.get("position").value;
	var cell = grid.children[pos];
	Logic.createSkillWithModel(model, cell, function(createdSkill) {
		console.log("Skill at position " + pos + " created");
	});
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
	draggableItem.startDrag(dragHandler);
	if (dragHandler)
		dragHandler.target = draggableItem;
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
