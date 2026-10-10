import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Controls

Scope {
    id: root
    property bool barVisible: true
    IpcHandler {
	target: "bar"
	function toggle(): void {
	    barVisible = !barVisible;
	}
    }
    Variants {
	model: Quickshell.screens

	PanelWindow {
	    required property var modelData
	    screen: modelData
	    visible: root.barVisible
	    anchors {
		top:true
		left:true
		right:true
	    }
	    implicitHeight: 25
	    color: "transparent"
	    Rectangle {
		anchors.fill: parent
		color: "#d01e1e2e"
		RowLayout {
		    anchors.fill: parent
		    anchors.leftMargin: 10
		    anchors.rightMargin: 10

		    Icon {}
		    Workspaces {}
		    Item { Layout.fillWidth: true }
		    RowLayout {
			spacing: 7.5
			Tray {}
			Volume {}
			Network {}
			Battery {}
			Clock {}
		    }
		}
	    }
	}
    }
}
//ShellRoot {
//    Variants {
//	model: Quickshell.screens
//	PanelWindow {
//	    required property var modelData
//	    screen: modelData
//	    //visible: false
//    	    anchors {
//    	        top:true
//    	        left:true
//    	        right:true
//    	    }
//	    //margins.top: 3
//	    //margins.right: 8
//	    //margins.left: 8
//	    //implicitWidth: 500
//    	    implicitHeight: 25
//    	    //color: "#ed1e1e2e"
//	    color: "transparent"
//	    Rectangle {
//		anchors.fill: parent
//		color: "#d01e1e2e"
//		//radius: 20
//		RowLayout {
//    	    	    anchors.fill: parent
//    	    	    anchors.leftMargin: 10
//    	    	    anchors.rightMargin: 10
//
//	    	    Icon {}
//	    	    Workspaces {}
//	    	    //Clock { anchors.centerIn: parent }
//
//    	    	    Item { Layout.fillWidth: true }
//	    	    RowLayout {
//	    	        //Layout.alignment: Qt.AlignRight
//	    	        spacing: 7.5 
//			Tray {}
//	    	        Volume {}
//	    	        Network {}
//	    	        Battery {}
//	    	        Clock {}
//	    	    }
//	    	}
//	    }
//
//    	}
//    }
//}
