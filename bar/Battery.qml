import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 6

    property var battery: UPower.displayDevice
    property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property int level: Math.round(battery.percentage * 100)
    readonly property string icon: {
	if (charging) return String.fromCodePoint(0xF0084)
	if (level >= 100) return String.fromCodePoint(0xF0079)
	if (level <= 10) return String.fromCodePoint(0xF0083)

	return String.fromCodePoint(0xF007A + Math.floor(level / 10) - 1)
    }
    Text {
	text: root.icon 
	color: root.charging ? "#89b4fa" : root.level <= 15 ? "#f39ba8" : root.level <= 30 ? "#fab387" : "#a6e3a1"

	font {
	    family: "JetBrainsMono Nerd Font Propo"
	    pixelSize: 12
	}
    }
    Text {
	text: root.level + "%"
	color: "#cdd6f4"
	font {
	    family: "Ubuntu"
	    pixelSize: 13
	}
    }
}
//Text {
//    text: UPower.displayDevice.percentage * 100 + "%"
//    color: "#cdd6f4"
//    font {
//    	family: "SF"
//    	letterSpacing: -1
//    	pixelSize: 14
//    	weight: 600
//    }
//
//}
