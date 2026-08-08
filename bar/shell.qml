import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    Variants {
	model: Quickshell.screens
	PanelWindow {
	    required property var modelData
	    screen: modelData
    	    anchors {
    	        top:true
    	        left:true
    	        right:true
    	    }
    	    implicitHeight: 30
    	    //color: "#313244"
    	    color: "#1e1e2e"
    	    RowLayout {
    	        anchors.fill: parent
    	        anchors.leftMargin: 3
    	        anchors.rightMargin: 10

		Icon {}
		Workspaces {}
		Clock { anchors.centerIn: parent }

    	        Item { Layout.fillWidth: true }
		RowLayout {
		    //Layout.alignment: Qt.AlignRight
		    spacing: 12
		    Volume {}
		    Network {}
		    Battery {}
		}
	    }

    	}
    }
}
