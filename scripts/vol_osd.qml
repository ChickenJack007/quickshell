import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    PwObjectTracker {
	objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
	target: Pipewire.defaultAudioSink?.audio

	    function onVolumeChanged() {
		root.shouldShowOsd = true;
		hideTimer.restart();
	    }
    }

    property bool shouldShowOsd: false

    Timer {
	id: hideTimer
	interval: 1000
	onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
	active: root.shouldShowOsd

	PanelWindow {
	    anchors.top: true
	    margins.top: 8
	    margins.right: 8
	    anchors.right: true
	    //margins.bottom: screen.height / 5
	    exclusiveZone: 0

	    implicitWidth: 200
	    implicitHeight: 25
	    color: "transparent"

	    mask: Region {}

	    Rectangle {
		anchors.fill: parent
		radius: height / 2
		color: "#8011111b"

		RowLayout {
		    anchors {
			fill: parent
			leftMargin: 5
			rightMargin: 7
			}

			IconImage {
			    implicitSize: 15
			    source: Quickshell.iconPath("audio-volume-high-symbolic")
			}

			Rectangle {
			    Layout.fillWidth: true

			    implicitHeight: 5
			    radius: 20
			    color: "#e01e1e2e"

			    Rectangle {
				anchors {
				    left: parent.left
				    top: parent.top
				    bottom: parent.bottom
				}

				implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
				radius: parent.radius
			    }
			}
		}
	    }
	}
    }
}

