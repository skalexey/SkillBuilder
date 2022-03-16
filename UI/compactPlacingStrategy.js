//.import "logic.js" as Logic

// Ref to a field's grid container
//var grid = null;
// Place suggestions
var suggestedPlaces = [];
var hidePlaceSuggestionsInterval = null;
var suggestedPlaceUsers = [];
var placeSuggestionsOwner = null;
//

function log(msg) {
	console.log("CompactPlacingStrategy: " + msg);
}

function onCellEntered(cell, item) {
	log("onCellEntered(" + cell.cellIndex + ")");

	if (cell.attachedSkill)
	{
		if (logic.isAParentOf(cell.attachedSkill, item))
			return false; // ? Why not to change to one or two level up?
		if (logic.isAChildOf(cell.attachedSkill, item))
			return false;
	}

	if (cell.attachedSkill && cell.attachedSkill !== item)
		showPlaceSuggestions(grid, cell);
	else if (isSuggestedCell(cell))
		addSuggestionsUser(cell);
	else if (placeSuggestionsActive())
		hidePlaceSuggestions();
	return true;
}

function onCellExited(cell, item) {
	log("onExited(" + cell.cellIndex + ")");
	if (isTheOnlySuggestionsUser(cell))
		hidePlaceSuggestions(true);
	else
		removeSuggestionsUser(cell);
}

function onItemDropped(cell, item) {
	log("Dropped at " + cell.cellIndex);
	if (cell.attachedSkill)
	{
		if (item === cell.attachedSkill)
			return false

		if (logic.isAParentOf(cell.attachedSkill, item))
			return false;

		if (logic.isAChildOf(cell.attachedSkill, item))
			return false;
	}

	var currentParent = item.model.parent;
	var parentModel = currentParent;
	if (cell.attachedSkill)
		parentModel = cell.attachedSkill.getModel().get("children");
	else
	{
		if (placeSuggestionsActive())
			parentModel = getPlaceSuggestionsOwner().attachedSkill.getModel();
		else
		{
			if (currentParent === rootSkillModel)
				parentModel = rootSkillModel;
			else
			{
				if (item.origin === "library")
					parentModel = rootSkillModel;
			}
		}
	}

	var targetCell = cell.attachedSkill ?
						getAutoPlaceSuggestion()
						: cell;
	if (!targetCell)
	{
		messageDialog.show("", "No place to put the skill");
		return false;
	}

	item.onDropped(targetCell.cellIndex, parentModel);
	logic.placeSkill(grid, item.model, function(createdItem) {
		targetCell.attachedSkill = createdItem;
	});
	hidePlaceSuggestions();
	return true;
}

function onDragActive(cell) {
	var skillParent = logic.getAttachedSkillParentItem(cell.attachedSkill, grid);
	if (skillParent)
		skillParent.stateParent();
}

function onDragEnd(cell) {
	var skillParent = logic.getAttachedSkillParentItem(cell.attachedSkill, grid);
	if (skillParent)
		skillParent.stateBase();
}

// Place suggestions functions
function getAutoPlaceSuggestion() {
	if (suggestedPlaces.length == 0)
	{
		log("Error! Trying to get auto place suggestion when there is no place suggestions active");
		return null;
	}
	return suggestedPlaces[0];
}

function getPlaceSuggestionsOwner() {
	log("getPlaceSuggestionsOwner: " + placeSuggestionsOwner);
	return placeSuggestionsOwner;
}

function placeSuggestionsActive() {
	log("placeSuggestionsActive: " + (suggestedPlaces.length > 0))
	return suggestedPlaces.length > 0;
}

function isTheOnlySuggestionsUser(cell) {
	return suggestedPlaceUsers.length == 1
			&& suggestedPlaceUsers.indexOf(cell) >= 0;
}

function addSuggestionsUser(user) {
	suggestedPlaceUsers.push(user);
	if (hidePlaceSuggestionsInterval)
	{
		logic.clearInterval(hidePlaceSuggestionsInterval);
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

function getFurthestChildModel(model) {
	var x = model.get("x").value;
	var y = model.get("y").value;
	var itemChildren = model.get("children");
	var sz = itemChildren.size();
	if (sz > 0)
	{	// Use the current direction
		var sortedChildren = [];
		for (var i = 0; i < sz; i++) {
			var child = itemChildren.at(i);
			var cX = child.get("x").value;
			var cY = child.get("y").value;
			var vecX = cX - x;
			var vecY = cY - y;
			var vec = {x: vecX, y: vecY, d: vecX * vecX + vecY * vecY};
			sortedChildren.push({x: cX, y: cY, v: vec, childModel: child});
		}
		sortedChildren.sort(function(a, b) {
			return b.v.d - a.v.d;
		});
		return sortedChildren[0];
	}
	return null;
}

function showPlaceSuggestions(grid, cell) {
	if (suggestedPlaces.length > 0)
		hidePlaceSuggestions();

	if (!cell.attachedSkill)
		return;

	addSuggestionsUser(cell);
	placeSuggestionsOwner = cell;

	function checkAndPushCell(x, y) {
		var index = logic.getCellIndex(x, y);
		var c = grid.children[index];
		if (!c.attachedSkill)
		{
			suggestedPlaces.push(c);
			c.state = "suggested";
		}
	}

	function furthestChildPlaceSuggestion(model) {
		var furthestChild = getFurthestChildModel(model);
		if (furthestChild)
		{
			var dir = furthestChild.v;
			if (dir.y > 0)
			{
				if (furthestChild.y >= 0 && furthestChild.y < (Constants.fieldSize - 1))
					checkAndPushCell(furthestChild.x, furthestChild.y + 1); // bottom
			}
			else if (dir.x > 0)
			{
				if (furthestChild.x >= 0 && furthestChild.x < (Constants.fieldSize - 1))
					checkAndPushCell(furthestChild.x + 1, furthestChild.y); // right
			}
			return true;
		}
		else // No children in the attached skill
			return false;
	}

	if (furthestChildPlaceSuggestion(cell.attachedSkill.getModel()))
		return;
	// No children in the attached skill
	// Check if it has a parent and choose the opposite direction
	var x = cell.attachedSkill.getModel().get("x").value;
	var y = cell.attachedSkill.getModel().get("y").value;
	var attachedSkillParent = cell.attachedSkill.getModel().parent.parent;
	if (attachedSkillParent && attachedSkillParent.has("x")) // Not the root
//		if (furthestChildPlaceSuggestion(attachedSkillParent, true))
	{
		var furthestChild = getFurthestChildModel(attachedSkillParent);
		if (furthestChild)
		{
			// Choose the opposite direction
			var dir = furthestChild.v;
			if (dir.y > 0)
			{
				if (x >= 0 && x < (Constants.fieldSize - 1))
					checkAndPushCell(x + 1, y); // right

			}
			else if (dir.x > 0)
			{
				if (y >= 0 && y < (Constants.fieldSize - 1))
					checkAndPushCell(x, y + 1); // bottom
			}
			return true;
		}
	}

	// Any direction is possible
	if (y >= 0 && y < (Constants.fieldSize - 1))
		checkAndPushCell(x, y + 1); // bottom
	if (x >= 0 && x < (Constants.fieldSize - 1))
		checkAndPushCell(x + 1, y); // Right
}

function hidePlaceSuggestions(delayed) {
	function job() {
		if (hidePlaceSuggestionsInterval)
		{
			logic.clearInterval(hidePlaceSuggestionsInterval);
			hidePlaceSuggestionsInterval = null;
		}

		for (var i = 0; i < suggestedPlaces.length; i++)
			suggestedPlaces[i].state = "base";
		suggestedPlaces = [];
		suggestedPlaceUsers = [];
		placeSuggestionsOwner = null;
	}

	if (delayed)
		hidePlaceSuggestionsInterval = logic.setInterval(job, 100);
	else
		job();
}
