import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

RowLayout {
    id:root
    spacing: 5

    property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink && sink.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

    readonly property string icon: {
	if (!ready) return String.fromCodePoint(0xF0581)
	//if (muted) return String.fromCodePoint(f0e08)
	if (muted) return "󰸈"
	if (vol === 0) return String.fromCodePoint(0xF0581)
	if (vol<= 35) return String.fromCodePoint(0xF057F)
	if (vol<= 64) return String.fromCodePoint(0xF0580)

	return String.fromCodePoint(0xF057E)
    }

    Text {
	text: root.icon
	color: "#cdd6f4"
	font {
	    family: "JetBrainsMono Nerd Font Propo"
	    pixelSize: 14
	}
    }

    Text {
	text: {
	    if (!root.ready) return "-"
	    if (root.muted) return "Muted"
	    return root.vol + "%"
	}
	color: root.muted ? "#f398ba" : "#cdd6f4"
	font {
	    family: "SF Pro Display"
	    pixelSize: 13
	    weight: 500
	}
    }
    
    PwObjectTracker {
	objects: [root.sink]
    }
    //MouseArea {
    //    anchors.fill: parent
    //    onClicked: Quickshell.execDetached("hyprpwcenter")
    //}
}
