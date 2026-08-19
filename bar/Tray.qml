import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Widgets

//RowLayout {
//    id: root
//    spacing: 4
//    Repeater {
//	model: SystemTray.items
//    
//	delegate: Item {
//	    required property SystemTrayItem modelData
//	    Layout.preferredWidth: 13
//	    Layout.preferredHeight: 12
//    
//	    Image {
//		anchors.fill: parent
//		source: modelData.icon
//		fillMode: Image.PreserveAspectFit
//		smooth: true
//		sourceSize.width: 16
//		sourceSize.height: 16
//	    }
//    
//	    MouseArea {
//		anchors.fill: parent
//		acceptedButtons: Qt.LeftButton | Qt.RightButton
//		cursorShape: Qt.pointingHandCursor
//    
//		onClicked: mouse => {
//		    if (mouse.button === Qt.LeftButton) {
//			modelData.activate();
//		    } else if (mouse.button === Qt.RightButton) {
//			if (modelData.hasMenu) {
//			    modelData.display(root, mouse.x, mouse.y);
//
//			}
//		    }
//		}
//	    }
//        }
//    }
//}
RowLayout {
    id: trayIcons
    spacing: 4

    Repeater {
	model: SystemTray.items

	MouseArea {
	    id: trayDelegate
	    required property SystemTrayItem modelData

	    Accessible.role: Accessible.Button
	    Accessible.name: modelData.tooltipTitle || modelData.title || "System tray item"

	    Layout.preferredWidth: 13
    	    Layout.preferredHeight: 12

    	    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    	    onClicked: (mouse) => {
		if (mouse.button === Qt.LeftButton) {
		  modelData.activate()
		} else if (mouse.button === Qt.RightButton) {
		    if (modelData.hasMenu) {
			menuAnchor.open()
		    }
		} else if (mouse.button === Qt.MiddleButton) {
		    modelData.secondaryActivate()
		}
    	    }

    	IconImage {
	    anchors.centerIn: parent
	    source: trayDelegate.modelData.icon
	    implicitSize: 13
    	}

	QsMenuAnchor {
	    id: menuAnchor
	    menu: trayDelegate.modelData.menu

	    anchor.window: trayDelegate.QsWindow.window
	    anchor.adjustment: PopupAdjustment.Flip
	    anchor.onAnchoring: {
		const window = trayDelegate.QsWindow.window;
		const widgetRect = window.contentItem.mapFromItem(
		trayDelegate, 0, trayDelegate.height,
		trayDelegate.width, trayDelegate.height);
		menuAnchor.anchor.rect = widgetRect;
	    }
    	}
    }
}
}
