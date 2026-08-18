import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 5
    Repeater {
        model: SystemTray.items
    
        delegate: Item {
    	required property SystemTrayItem modelData
    	Layout.preferredWidth: 13
    	Layout.preferredHeight: 12
    
    	Image {
    	    anchors.fill: parent
    	    source: modelData.icon
    	    fillMode: Image.PreserveAspectFit
    	    smooth: true
    	    sourceSize.width: 16
    	    sourceSize.height: 16
    	}
    
    	MouseArea {
    	    anchors.fill: parent
    	    acceptedButtons: Qt.LeftButton | Qt.RightButton
    	    cursorShape: Qt.pointingHandCursor
    
    	    onClicked: mouse => {
    		if (mouse.button === Qt.LeftButton) {
    		    modelData.activate();
                } else if (mouse.button === Qt.RightButton) {
                    if (modelData.hasMenu) {
                        modelData.display(root, mouse.x, mouse.y);
                    }
    		}
    	    }
    	}
        }
    }
}
