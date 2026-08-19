//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import QtQuick
import "./bar"
import "./scripts/"

Scope {
    Bar {}
    Osd {}
    AppLauncher {}
}
