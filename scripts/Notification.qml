import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "./config.js" as Config

Scope {
    id: root
    ListModel {id:history}
    NotificationServer {
	id: server
	property bool centerOpen: false
	actionsSupported: true
	bodySupported: true
	imageSupported: true

	onNotification: n => {
	    history.insert(0, {
	        summary: n.summary,
	        body: n.body,
	        appName: n.appName,
	        urgency: n.urgency,
	        time: Qt.formatDateTime(new Date(), "HH:MM")
	    })
	    n.tracked = true
	}
    }

    IpcHandler {
	target: "notifications"

	//function toggle(): void { root.centerOpen = !root.centerOpen }
	//function show(): void { root.centerOpen = true }
	//function hide(): void { root.centerOpen = false }
	function toggle(): void { server.centerOpen = !server.centerOpen }
	function show(): void { server.centerOpen = true }
	function hide(): void { server.centerOpen = false }
    }


    //single notification
    PanelWindow {
	anchors { top:true; right:true }
	margins { top: 32; right: 7}
	implicitWidth: 350
	implicitHeight: Math.max(1, column.implicitHeight)
	color: "transparent"

	exclusionMode: ExclusionMode.Ignore

	ColumnLayout {
	    id: column
	    width: parent.width
	    spacing: 10

	    Repeater {
		model: server.trackedNotifications
		delegate: Rectangle {
		    id: card
		    required property var modelData

		    Timer {
			running: card.modelData.urgency !== NotificationUrgency.Critical
			//interval: Config.notifications.timeout
			interval: 5000
			onTriggered: card.modelData.dismiss()
		    }

		    Layout.fillWidth: true
		    Layout.preferredHeight: layout.implicitHeight + 20
		    //Layout.preferredHeight: 60
		    radius: 4
		    color: Config.colors.base
		    border.width: 1
		    border.color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.blue

		    RowLayout {
			id: layout
			anchors.fill: parent
			anchors.margins: 10
			spacing: 10

			Image {
			    Layout.preferredHeight: 36
			    Layout.preferredWidth: 36
			    Layout.alignment: Qt.AlignTop
			    fillMode: Image.PreserveAspectFit
			    visible: source.toString() !== ""
			    source: card.modelData.image || card.modelData.appIcon || ""
			}

			ColumnLayout {
			    Layout.fillWidth: true
			    spacing: 2

			    Text {
				Layout.fillWidth: true
				text: card.modelData.summary
				color: Config.colors.text
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize
				font.bold: true
				elide: Text.ElideRight
			    }
			    Text {
				Layout.fillWidth: true
				visible: text !== ""
				text: card.modelData.body
				color: Config.colors.text
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize - 1
				wrapMode: Text.WordWrap
			    }

			    Text {
				visible: model.appName !== ""
				text: model.appName
				color:Config.colors.surface1
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize - 3
			    }
			}
		    }

		    MouseArea {
			anchors.fill: parent
			onClicked: card.modelData.dismiss()
		    }
		}
	    }
	}
    }
    //notification center
    PanelWindow {
	id: center
	visible: server.centerOpen
	anchors { top:true; right:true }
	margins { top: 32; right: 7}
	exclusionMode: ExclusionMode.Ignore

	color: "transparent"
	implicitWidth: 350
	implicitHeight: centerCol.implicitHeight + 24

	Rectangle {
	    anchors.fill: parent
	    radius: 6
	    color: Config.colors.base
	    border.width: 1
	    border.color: Config.colors.blue

	    ColumnLayout {
		id: centerCol
	    	anchors.fill:parent
	    	anchors.margins: 12
	    	spacing: 10

		RowLayout {
		    Layout.fillWidth: true
		    Text {
			Layout.fillWidth: true
		    	text: "Notifications"
		    	color: Config.colors.lavender
		    	font.family: Config.bar.fontFamily
		    	font.pixelSize: Config.bar.fontSize + 2
		    	font.bold: true
		    }
		    Text {
			text: "Clear all"
		    	visible: history.count > 0
		    	color: Config.colors.red
		    	font.family: Config.bar.fontFamily
		    	font.pixelSize: Config.bar.fontSize - 1
		    	MouseArea {
			    anchors.fill: parent
			    onClicked: history.clear
			}
		    }
		}
	    Repeater {
		model: history
		delegate: Rectangle {
		    id: centerCard
		    required property var modelData

		    Layout.fillWidth: true
		    Layout.preferredHeight: layout.implicitHeight + 20
		    //Layout.preferredHeight: 60
		    radius: 4
		    color: Config.colors.base
		    border.width: 1
		    border.color: modelData.urgency === NotificationUrgency.Critical ? Config.colors.red : Config.colors.blue

		    RowLayout {
			id: layout
			anchors.fill: parent
			anchors.margins: 10
			spacing: 10

			Image {
			    Layout.preferredHeight: 36
			    Layout.preferredWidth: 36
			    Layout.alignment: Qt.AlignTop
			    fillMode: Image.PreserveAspectFit
			    visible: source.toString() !== ""
			    source: centerCard.modelData.image || centerCard.modelData.appIcon || ""
			}

			ColumnLayout {
			    Layout.fillWidth: true
			    Layout.fillHeight: true
			    spacing: 2

			    Text {
				Layout.fillWidth: true
				text: centerCard.modelData.summary
				color: Config.colors.text
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize
				font.bold: true
				elide: Text.ElideRight
			    }
			    Text {
				Layout.fillWidth: true
				visible: text !== ""
				text: centerCard.modelData.body
				color: Config.colors.text
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize - 1
				wrapMode: Text.WordWrap
			    }

			    Text {
				visible: model.appName !== ""
				text: model.appName
				color:Config.colors.surface1
				font.family: Config.bar.fontFamily
				font.pixelSize: Config.bar.fontSize - 3
			    }
			}
			ColumnLayout {
			    Layout.fillWidth: true
			    Layout.fillHeight: true
			    spacing: 2
			
			    Text {
		    	        text: model.time
		    	        color: Config.colors.surface1
		    	        font.family: Config.bar.fontFamily
		    	        font.pixelSize: Config.bar.fontSize - 3

		    	    }
		    	    Text {
			        text: "x"
		                color:Config.colors.surface1
		                font.family: Config.bar.fontFamily
		                font.pixelSize: Config.bar.fontSize - 3
		                MouseArea {
		                    anchors.fill: parent
		                    onClicked: history.remove(modelData)
			        }
			    }
			}
		    }

		    MouseArea {
			anchors.fill: parent
		        onClicked: history.remove(modelData)
		    }
	    }
	}
    }
}
}
}
