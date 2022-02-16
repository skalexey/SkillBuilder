import QtQuick
import QtQuick.Controls

Row {
	id: mainBlock
	width: parent.width
	height: parent.height
	visible: false

	Column {
		id: leftBlock
		width: parent.width * 0.25
		height: parent.height
		z: 1

		Text {
			id: skillLibraryTitle
			text: "Skill library"
			anchors.horizontalCenter: parent.horizontalCenter
		}

		ListView {
			id: skillLibraryList
			width: parent.width
			implicitHeight: contentItem.childrenRect.height
			model: dmbModel.contentModel.get("skillLibrary").listModel

			delegate: Item {
				// The item holder (to let the skill be detached from it)
				// and not be affected by the ListView alignments
				id: listItem
				width: parent.width
				height: skill.height

				MouseArea {
					id: mouseArea
					width: parent.width
					height: parent.height

					QtObject {
						id: local
						property var draggableItem: null
						function createDraggableItem(from, dragHandler) {
							var c = null;
							function create() {
	//							console.log("Create component PropListBlock.qml");
								c = Qt.createComponent("Skill.qml");
								if (c.status === Component.Ready)
									finishCreation();
								else
								{
	//								console.log("Creation is not ready yet. Wait")
									c.statusChanged.connect(finishCreation);
								}
							}

							function finishCreation() {
	//							console.log("finish creation")
								if (c.status === Component.Ready)
								{
									//console.log("finishCreation");
									local.draggableItem = c.createObject(skillLibraryList, {
										model: from.model,
										fieldRef: field,
										x: listItem.x,
										y: listItem.y
									});
									local.draggableItem.startDrag(mouseArea.drag);
									if (dragHandler)
										dragHandler.target = local.draggableItem;

								}
								else if (c.status === Component.Error)
									// Error Handling
									console.log("Error loading component:", c.errorString());
							}
							create();
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
								console.log("draggableItem destroyed")
							}
						}
					}

					drag.target: null
					onPressed: function(mouse) {
						console.log("Skill cell pressed");
						local.createDraggableItem(skill, drag);
					}

					drag.onActiveChanged: function() {
						console.log("MouseArea.drag.onActiveChanged(" + drag.active + ")");
						if (!drag.active)
							local.destroyDraggableItem(drag);
					}

					Skill {
						id: skill
						model: value
						fieldRef: field
					}
				}
			}
		}
	}

	Field {
		id: field
		width: parent.width - leftBlock.width
		height: parent.height
	}

}
