import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 4

    Repeater {
	model: 9
	Rectangle {
	    id: wsButton
	    required property int index

	    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
	    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

	    //implicitWidth: wsButton.ws ? label.implicitWidth + 14 : 0
	    //implicitHeight: wsButton.ws ? 22 : 0
	    //radius: wsButton.ws ? 6 : 0
	    //color: wsButton.ws ? "#1e1e2e" : "#313244"
	    //color: isActive ? "#89b4fa" : "#cdd6f4"
	    implicitWidth: label.implicitWidth + 12
	    implicitHeight: 20
	    radius: 6
	    //color: wsButton.ws ? "#181825" : "#1e1e2e"
	    color: wsButton.ws ? "#313244" : "#11111b"

	    Behavior on color {
		ColorAnimation { duration: 150 }
	    }

	    Text {
		id: label
		anchors.centerIn: parent
		//text: wsButton.index + 1
		text: wsButton.isActive ? "󰧨" : "󰇄"
		//color: wsButton.isActive ? "#89b4fa" : (wsButton.ws ? "#cdd6f4" : "#9399b2")
		color: wsButton.ws ? "#cdd6f4" : "#9399b2"

		font {
		    family: "SF Pro Display"
		    pixelSize: 14
		    weight: 500
		}
	    }

	    MouseArea {
		anchors.fill: parent
		onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
	    }
	}
    }
}
