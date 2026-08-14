import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

RowLayout {
    id:root
    spacing: 3

    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired)
    property var active: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null
    property var eactive: wiredDevice ? wiredDevice.networks.values.find(n => n.connected) : null

    readonly property real signal: active ? active.signalStrength : 0

    readonly property string icon: {
	//if (eactive) return "󰈀"
	if (eactive) return String.fromCodePoint(0xF0200)
	if (!Networking.wifiEnabled) return String.fromCodePoint(0xF05AA)
	if (!active) return String.fromCodePoint(0xF092D)

	let teir = signal >= 0.75 ? 4 : signal >= 0.50 ? 3 : signal >= 0.25 ? 2 : 1

	return String.fromCodePoint(0xF091f + (teir - 1) * 3)
    }

    Text {
	text: root.icon
	color: Networking.wifiEnabled ? !root.active ? "#f38ba8" : "#cdd6f4" : eactive ? "#cdd6f4" : "#9399b2"
	font {
	    family: "JetBrainsMono Nerd Font Propo"
	    pixelSize: 12
	}
    }
    MouseArea {
	anchors.fill: parent
	//onClicked: DesktopEntry.command("rofi -show drun")
	 onClicked: Quickshell.execDetached("/home/chess/.config/rofi/rofi-wifi-menu.sh")
    }
    //Text {
    //    text: {
    //        if (!Networking.wifiEnabled) return "Off"
    //        f0200
    //        if (!root.active) return "Disconnected"
    //        return root.active.name
    //    }
    //    color: "#cdd6f4"
    //    font {
    //        family: "SF Pro Display"
    //        weight: 500
    //    }
    //}
}
