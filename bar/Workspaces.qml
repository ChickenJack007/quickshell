import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 4

    Repeater {
	model: 5
	Rectangle {
	    id: wsButton
	    required property int index

	    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
	    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

	    implicitWidth: label.implicitWidth + 10
	    implicitHeight: 18
	    radius: 3
	    color: wsButton.ws ? "#d0313244" : "#a011111b"

	    Behavior on color {
		ColorAnimation { duration: 150 }
	    }

	    Text {
		id: label
		anchors.centerIn: parent
		text: wsButton.isActive ? "󰧨" : "󰇄"
		color: wsButton.ws ? "#e0cdd6f4" : "#a09399b2"

		font {
		    family: "SF Pro Display"
		    pixelSize: 13
		    weight: 640
		}
	    }

	    MouseArea {
		anchors.fill: parent
		onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
	    }
	}
    }
}
