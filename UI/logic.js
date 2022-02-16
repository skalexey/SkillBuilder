var createdSkill = null;
var draggableItem = null;

function createSkill(from, onCreated) {
	var c = null;
	function create() {
//		console.log("Create component PropListBlock.qml");
		c = Qt.createComponent("Skill.qml");
		if (c.status === Component.Ready)
			finishCreation(from, onCreated);
		else
		{
//			console.log("Creation is not ready yet. Wait")
			c.statusChanged.connect(function() {
				finishCreation(from, onCreated);
			});
		}
	}
	function finishCreation(from, onCreated) {
//		console.log("finish creation")
		if (c.status === Component.Ready)
		{
			//console.log("finishCreation");
			createdSkill = c.createObject(skillLibraryList, {
				model: from.model,
				fieldRef: field
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
