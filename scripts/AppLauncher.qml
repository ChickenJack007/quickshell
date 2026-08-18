import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Scope {
    id: root
    IpcHandler {
        target: "launcher"
    
        function toggle(): void {
	    launcherPanel.visible = !launcherPanel.visible
	    if (launcherPanel.visible) {
		searchInput.text = ""
		selectedIndex = -1
		searchInput.forceActiveFocus()
	    }
        }
    }

    property int selectedIndex: 0

    ScriptModel {
	id: filteredApps
	objectProp: "id"
	values: {
	    const all = [...DesktopEntries.applications.values];
	    const q = searchInput.text.trim().toLowerCase();
	    if (q === "") return all.sort((a, b) => a.name.localeCompare(b.name));
	    return all.filter( d=>
		(d.name && d.name.toLowerCase().includes(q)) ||
	    	(d.genericName && d.genericName.toLowerCase().includes(q)) ||
	    	(d.keywords && d.keywords.some(k => k.toLowerCase().includes(q))) ||
            	(d.categories && d.categories.some(c => c.toLowerCase().includes(q)))
	    ).sort((a, b) => {
		const an = a.name.toLowerCase();
	    	const bn = b.name.toLowerCase();
	    	const aStarts = an.startsWith(q);
	    	const bStarts = bn.startsWith(q);
	    	if (aStarts && !bStarts) return -1;
	    	if (!aStarts && bStarts) return 1;
	    	return an.localeCompare(bn);
	    });
	}
    }
    function launchApp(entry) {
	entry.execute();
	launcherPanel.visible = false;
    }

    PanelWindow {
	id: launcherPanel
	visible: false
	focusable: true
	color: "transparent"
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
	WlrLayershell.namespace: "qs-launcher"

	exclusionMode: ExclusionMode.Ignore

	anchors {
	    top: true
	    right: true
	    left: true
	    bottom: true
	}

	//Dark overlay backdrop
	MouseArea {
	    anchors.fill: parent
	    onClicked: launcherPanel.visible = false

	    Rectangle {
		anchors.fill: parent
		color: "#33000000"
	    }
	}
	//centered launcher
	Rectangle {
	    id: launcherBox
	    anchors.centerIn: parent
	    width: 700
	    height: 500
	    radius: 8
	    color: "#d01e1e2e"
	    border.color: "#89b4fa"
	    border.width: 1

	    ColumnLayout {
		anchors.fill: parent
		anchors.margins: 16
		spacing: 12

		//header
		Text {
		    text: "Applications"
		    color: "#c889b4fa"
		    font.pixelSize: 12
		    font.bold: true
		}

		//search bar
		Rectangle {
		    Layout.fillWidth: true
		    height: 44
		    radius: 10
		    color: "#98181825"
		    border.color: "#b889b4fa"
		    border.width: 1

		    RowLayout {
			anchors.fill: parent
			anchors.leftMargin: 14
			anchors.rightMargin: 14
			spacing: 10

			Text {
			    text: " "
			    color: "#70cdd6f4"
			    font.pixelSize: 12
			    Layout.alignment: Qt.AlignVCenter
			}

			TextInput {
			    id: searchInput
			    Layout.fillWidth: true
			    Layout.alignment: Qt.AlignVCenter
			    color: "#cdd6f4"
			    font.pixelSize: 13
			    clip: true
			    focus: true
			    Accessible.role: Accessible.EditableText
			    Accessible.name: "Search applications"

			    Text {
				anchors.fill: parent
				text: "Search..."
				color:"#313244"
				visible: !parent.text && !parent.activeFocus
				Layout.alignment: Text.AlignVCenter
			    }

			    onTextChanged: root.selectedIndex = text === "" ? -1 : 0

			    Keys.onEscapePressed: launcherPanel.visible = false

			    Keys.onPressed: event => {
				if (event.key === Qt.Key_Down) {
				    event.accepted = true;
				    root.selectedIndex = Math.min(root.selectedIndex + 1, resultsList.count - 1);
				    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
				} 
				else if (event.key === Qt.Key_Up) {
				    event.accepted = true;
                  		    root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                  		    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
				}
				else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
				    event.accepted = true;
				    if (root.selectedIndex >= 0) {
					const entry = filteredApps.values[root.selectedIndex];
					if (entry) root.launchApp(entry);
				    }
				}
				else if (event.key === Qt.Key_Tab) {
				    event.accepted = true;
				    root.selectedIndex = Math.min(root.selectedIndex + 1, resultsList.count - 1);
				    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
				}
			    }
			}
		    }
		}

		//Results count
		Text {
		    text: resultsList.count + " application" + (resultsList.count !== 1 ? "s" : "")
		    color: "#c8cdd6f4"
		    font.pixelSize: 10
		}

		//App list
		ListView {
		    id: resultsList
		    Layout.fillWidth: true
		    Layout.fillHeight: true
		    model: filteredApps 
		    clip: true
		    spacing: 2
		    boundsBehavior: Flickable.StopAtBounds
		    currentIndex: root.selectedIndex
		    highlightMoveDuration: 150
		    highlightMoveVelocity: -1

		    highlight: Rectangle {
			radius: 8
			color: "#887f849c"
			visible: root.selectedIndex >= 0

			Rectangle {
			    width: 3
			    height: 24
			    radius: 2
			    color: "#89b4fa"
			    anchors.left: parent.left
			    anchors.leftMargin: 2
			    anchors.verticalCenter: parent.virticalCenter
			}
		    }

		    delegate: Rectangle {
			id: delegateRoot
			required property var modelData
			required property int index

			Accessible.role: Accessible.Button
			Accessible.name: (modelData.name ?? "application") + (modelData.genericName ? " - " + modelData.genericName : "")

			width: resultsList.width
			height: 44
			radius: 8
			color: "transparent"

			RowLayout {
			    anchors.fill: parent
			    anchors.leftMargin: 12
			    anchors.rightMargin: 12
			    spacing: 12

			    //App icon
			    Item {
				width: 28
				height: 28
				Layout.alignment: Qt.AlignVCenter

				IconImage {
				    anchors.fill: parent
				    source: Quickshell.iconPath(delegateRoot.modelData.icon ?? "", true)
				    visible: (delegateRoot.modelData.icon ?? "") !== ""
				}

				//Fallback icon
				Text {
				    anchors.centerIn: parent
				    text: ""
				    color: "#cdd6f4"
				    font.pixelSize: 20
				    visible: (delegateRoot.modelData.icon ?? "") === ""
				}
			    }

			    //App info
			    ColumnLayout {
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignVCenter
				spacing: 1

				Text {
				    text: delegateRoot.modelData.name ?? ""
				    color: root.selectedIndex === delegateRoot.index ? "#cdd6f4" : "#78cdd6f4"
				    font.pixelSize: 12
				    elide: Text.ElideRight
				    Layout.fillWidth: true
				}

				Text {
				    text: delegateRoot.modelData.genericName ?? delegateRoot.modelData.comment ?? ""
				    color: "#313244"
				    font.pixelSize: 10
				    elide: Text.ElideRight
				    Layout.fillWidth: true
				    visible: text !== ""
				}
			    }
			}
			MouseArea {
			    anchors.fill: parent
			    hoverEnabled: true
			    cursorShape: Qt.PointingHandCursor
			    onClicked: root.launchApp(delegateRoot.modelData)
			    onPositionChanged: root.selectedIndex = delegateRoot.index
			}
		    }

		    //Empty state
		    Text {
			anchors.centerIn: parent
			text: "No apps"
			color: "#313244"
			font.pixelSize: 13
			visible: resultsList.count === 0 &searchInput !== ""
		    }
		}
		// Footer hints
		//RowLayout {
		//    Layout.fillWidth: true
		//     spacing: 16

         	//     Row {
		//	spacing: 4
		//	Rectangle {
		//	    width: hintUp.width + 8; height: 18; radius: 4; color: "#1e1e2e" 
		//	    Text { id: hintUp; anchors.centerIn: parent; text: "↑↓"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font }
		//	}
		//	Text { text: "navigate"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font; anchors.verticalCenter: parent.verticalCenter }
		//    }

         	//    Row {
		//	spacing: 4
		//	Rectangle {
		//	    width: hintEnter.width + 8; height: 18; radius: 4; color: "#1e1e2e"
		//	    Text { id: hintEnter; anchors.centerIn: parent; text: "⏎"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font }
		//	}
		//	Text { text: "launch"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font; anchors.verticalCenter: parent.verticalCenter }
         	//    }

         	//    Row {
		//	spacing: 4
		//	Rectangle {
		//	    width: hintEsc.width + 8; height: 18; radius: 4; color: "#1e1e2e"
		//	    Text { id: hintEsc; anchors.centerIn: parent; text: "esc"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font }
		//	}
		//	Text { text: "close"; color: "#cdd6f4"; font.pixelSize: 10; font.family: root.font; anchors.verticalCenter: parent.verticalCenter }
		//    }

         	//    Item { Layout.fillWidth: true }
		//}
	    }
	}
    }
}
