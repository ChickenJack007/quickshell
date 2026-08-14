import Quickshell
import QtQuick

Text {
    //anchors.centerIn: parent
    text: Qt.formatDateTime(clock.date, "h:mm A")
    //text: Qt.formatDateTime(clock.date, "hh:mm")
    color: "#cdd6f4"
    font {
    	family: "SF Pro Display"
    	letterSpacing: -0.5
    	pixelSize: 14
    	weight: 600
    }
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}

