import Quickshell
import QtQuick

Rectangle {
    implicitWidth: 25
    implicitHeight: 20
    radius: 6
    color: "#181825"
    Text {
	anchors.centerIn: parent
        text: "󰣇"
        color: "#cdd6f4"
        font {
	   family: "SF Pro Display"
	   //letterSpacing: 
	   pixelSize: 16
	   weight: 700
        }
    }
}
