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
	    //margins.top: 3
	    //margins.right: 8
	    //margins.left: 8
	    //implicitWidth: 500
    	    implicitHeight: 25
    	    //color: "#ed1e1e2e"
	    color: "transparent"
	    Rectangle {
		anchors.fill: parent
		color: "#d01e1e2e"
		//radius: 20
		RowLayout {
    	    	    anchors.fill: parent
    	    	    anchors.leftMargin: 10
    	    	    anchors.rightMargin: 10

	    	    Icon {}
	    	    Workspaces {}
	    	    //Clock { anchors.centerIn: parent }

    	    	    Item { Layout.fillWidth: true }
	    	    RowLayout {
	    	        //Layout.alignment: Qt.AlignRight
	    	        spacing: 8.5 
	    	        Volume {}
			Tray {}
	    	        Network {}
	    	        Battery {}
	    	        Clock {}
	    	    }
	    	}
	    }

    	}
    }
}
