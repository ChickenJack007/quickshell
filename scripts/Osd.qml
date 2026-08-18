import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland

Scope {
    id: root
    property bool shouldShowVol: false
    property bool volMuted: false
    property real vol: 0

    PwObjectTracker {
	objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
	target: Pipewire.defaultAudioSink?.audio ?? null

	    function onVolumeChanged() {
		root.vol = Pipewire.defaultAudioSink.audio.volume;
		root.shouldShowVol = true;
		hideVolTimer.restart();
	    }

	    function onMutedChanged() {
		root.volMuted = Pipewire.defaultAudioSink.audio.muted;
		root.shouldShowVol = true;
		hideVolTimer.false()
	    }
    }

    Timer {
	id: hideVolTimer
	interval: 1500
	onTriggered: root.shouldShowVol = false
    }

    property bool showBrightness: false
    property real maxBrightness: 1
    property real brightness: 0
    property bool _brightnessReady: false
    FileView {
	id: brightnessFile
	path: ""
	watchChanges: true
	onFileChanged: brightnessReadProc.running = true
    }

    Process {
	id: brightnessReadProc
	command: ["brightnessctl", "get"]
	running: false 
	stdout: StdioCollector {
	    onStreamFinished: {
		const val = parseInt(text.trim());
		if (!isNaN(val) && root.maxBrightness > 0) {
		    root.brightness = val / root.maxBrightness;
		    if (root._brightnessReady) {
			root.showBrightness = true;
			hideBriTimer.restart()
		    }
		    root._brightnessReady = true;
		}
	    }
	}
    }

    Process {
	id: backlightDiscovery
	command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo \"$p\" && cat \"${p%brightness}max_brightness\""]
	running: true
	stdout: StdioCollector {
	    onStreamFinished: {
		const lines = text.trim().split("\n");
		if (lines.length >= 2) {
		    const max = parseInt(lines[1]);
		    if (!isNaN(max) && max > 0) root.maxBrightness = max;
		    brightnessFile.path = lines[0];
		    brightnessReadProc.running = true;
		}
	    }
	}
    }
    Timer {
	id: hideBriTimer
	interval: 1500
	onTriggered: root.showBrightness = false
    }

    LazyLoader {
	active: root.shouldShowVol || root.showBrightness

	PanelWindow {
	    //visible: root.shouldShowVol
	    focusable: false
	    anchors {
		right: true
		top: true
	    }
	    margins.top: 8
	    margins.right: 8
	    //margins.bottom: screen.height / 5
	    exclusiveZone: 0

	    implicitWidth: 200
	    implicitHeight: 45
	    color: "transparent"

	    mask: Region {}

	    Rectangle {
		visible: root.shouldShowVol
		anchors.fill: parent
		radius: height / 2
		anchors.bottomMargin: 25

		Behavior on opacity { NumberAnimation { duration: 150}}
		color: "#801e1e2e"

		RowLayout {
		    anchors {
			fill: parent
			leftMargin: 5
			rightMargin: 7
		    }


			//IconImage {
			//    implicitSize: 15
			//    source: Quickshell.iconPath("audio-volume-high-symbolic")
			//}
			Text {
			    text: {
				if (root.volMuted || root.vol <= 0) return "󰖁";
              		  	if (root.vol < 0.33) return "󰕿";
              		  	if (root.vol < 0.66) return "󰖀";
              		  	return "󰕾";
			    }
			    color: "#cdd6f4"
			    font.pixelSize: 14
			    Layout.alignment: Qt.AlignHCenter
			}

			Rectangle {
			    Layout.fillWidth: true

			    implicitHeight: 8
			    radius: 20
			    color: "#6011111b"
			    clip: true

			    Rectangle {
				anchors {
				    left: parent.left
				    top: parent.top
				    bottom: parent.bottom
				    margins: 2
				}
				width: Math.max(0, (parent.width -4) * Math.max(0, Math.min(1, root.volMuted ? 0 : root.vol)))
				radius: 3
				color: "#89b4fa"

				//implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
				//radius: parent.radius
				Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic}}
			    }
			}
			Text{
			    text: root.volMuted ? "0%" : Math.round(root.vol * 100) + "%"
			    color: "#cdd6f4"
			    font.pixelSize: 10
			    Layout.alignment: Qt.AlignHCenter
			}
		}
	    }

	    Rectangle {
		visible: root.showBrightness
		anchors.fill: parent
		radius: height / 2
		anchors.topMargin: 25

		Behavior on opacity { NumberAnimation { duration: 150}}
		color: "#801e1e2e"

		RowLayout {
		    anchors {
			fill: parent
			leftMargin: 5
			rightMargin: 7
		    }


			//IconImage {
			//    implicitSize: 15
			//    source: Quickshell.iconPath("audio-volume-high-symbolic")
			//}
			Text {
			    text: {
              		  	return "󰃠";
			    }
			    color: "#cdd6f4"
			    font.pixelSize: 12
			    Layout.alignment: Qt.AlignHCenter
			}

			Rectangle {
			    Layout.fillWidth: true

			    implicitHeight: 8
			    radius: 20
			    color: "#6011111b"
			    clip: true

			    Rectangle {
				anchors {
				    left: parent.left
				    top: parent.top
				    bottom: parent.bottom
				    margins: 2
				}
				width: Math.max(0, (parent.width -4) * Math.max(0, Math.min(1, root.brightness)))
				radius: 3
				color: "#fab387"

				//implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
				//radius: parent.radius
				Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic}}
			    }
			}
			Text{
			    text: root.volMuted ? "0%" : Math.round(root.brightness * 100) + "%"
			    color: "#cdd6f4"
			    font.pixelSize: 10
			    Layout.alignment: Qt.AlignHCenter
			}
		}
	    }
	}
    }
}

