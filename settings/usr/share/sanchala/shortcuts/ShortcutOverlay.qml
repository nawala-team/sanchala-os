// SANCHALA OS - Shortcut Overlay QML
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: root
    visible: true
    width: 900
    height: 620
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    color: "transparent"
    title: "Keyboard Shortcuts"
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    
    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }
    MouseArea { anchors.fill: parent; onClicked: Qt.quit() }
    
    Rectangle {
        anchors.fill: parent
        anchors.margins: 20
        radius: 16
        color: "#E6212121"
        border.color: "#3d5afe"
        border.width: 2
        
        MouseArea { anchors.fill: parent }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16
            
            RowLayout {
                Layout.fillWidth: true
                Text { text: "⌨️ Keyboard Shortcuts"; font.pixelSize: 24; font.bold: true; color: "#fff" }
                Item { Layout.fillWidth: true }
                Text { text: "Press Escape to close"; font.pixelSize: 12; color: "#9e9e9e" }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: "#424242" }
            
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                columnSpacing: 32
                rowSpacing: 12
                
                ShortcutGroup { title: "🚀 Essential"; keys: "Super|App Launcher,Super+Space|Quick Search,Ctrl+Alt+T|Terminal,Super+E|Files,Super+I|Settings,Ctrl+Alt+L|Lock" }
                ShortcutGroup { title: "🪟 Windows"; keys: "Alt+Tab|Switch,Alt+F4|Close,Super+Up|Maximize,Super+Down|Minimize,F11|Fullscreen,Super+D|Desktop" }
                ShortcutGroup { title: "🖼️ Tiling"; keys: "Super+Left|Tile Left,Super+Right|Tile Right,Super+C|Center,Super+T|On Top" }
                ShortcutGroup { title: "🖥️ Desktops"; keys: "Super+1-4|Switch,Super+Shift+1-4|Move,Super+Ctrl+←→|Navigate,Super+F8|Grid" }
                ShortcutGroup { title: "📸 Screenshots"; keys: "Print|Full Screen,Shift+Print|Region,Alt+Print|Window" }
                ShortcutGroup { title: "🔊 Media"; keys: "Vol Keys|Volume,Play|Play/Pause,Next/Prev|Skip" }
            }
        }
    }
    
    component ShortcutGroup: ColumnLayout {
        property string title
        property string keys
        spacing: 4
        Text { text: title; font.pixelSize: 14; font.bold: true; color: "#3d5afe" }
        Repeater {
            model: keys.split(",")
            RowLayout {
                spacing: 8
                Rectangle {
                    width: kt.width + 10; height: 20; radius: 4; color: "#333"; border.color: "#555"
                    Text { id: kt; anchors.centerIn: parent; text: modelData.split("|")[0]; font.pixelSize: 10; color: "#e0e0e0" }
                }
                Text { text: modelData.split("|")[1]; font.pixelSize: 11; color: "#bdbdbd" }
            }
        }
        Item { height: 4 }
    }
}
