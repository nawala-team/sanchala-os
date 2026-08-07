// AppearancePage.qml - Theme and appearance
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: appearancePage
    property string selectedTheme: "auto"
    property string selectedAccent: "#3949AB"
    property string selectedWallpaper: "default-dark"
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Make it Yours"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Choose your theme and accent color"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Theme selection
        Label { text: "Theme"; font.weight: Font.Medium }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 16
            
            Repeater {
                model: [
                    { id: "light", name: "Light", icon: "weather-clear", bg: "#FFFFFF", fg: "#212121" },
                    { id: "dark", name: "Dark", icon: "weather-clear-night", bg: "#212121", fg: "#FFFFFF" },
                    { id: "auto", name: "Auto", icon: "system-switch-user", bg: "#666666", fg: "#FFFFFF" }
                ]
                
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 100
                    radius: 12
                    color: modelData.bg
                    border.color: selectedTheme === modelData.id ? Kirigami.Theme.highlightColor : "transparent"
                    border.width: 3
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Kirigami.Icon { source: modelData.icon; width: 32; height: 32; Layout.alignment: Qt.AlignHCenter; color: modelData.fg }
                        Label { text: modelData.name; color: modelData.fg; Layout.alignment: Qt.AlignHCenter }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: selectedTheme = modelData.id
                    }
                }
            }
        }
        
        // Accent color
        Label { text: "Accent Color"; font.weight: Font.Medium }
        
        GridLayout {
            columns: 6
            rowSpacing: 12
            columnSpacing: 12
            
            Repeater {
                model: ["#3949AB", "#1E88E5", "#00ACC1", "#43A047", "#7CB342", "#FDD835",
                        "#FB8C00", "#F4511E", "#E53935", "#D81B60", "#8E24AA", "#5E35B1"]
                
                delegate: Rectangle {
                    width: 48; height: 48
                    radius: 24
                    color: modelData
                    border.color: selectedAccent === modelData ? Kirigami.Theme.textColor : "transparent"
                    border.width: 3
                    
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        source: "checkmark"
                        width: 20; height: 20
                        visible: selectedAccent === modelData
                        color: "white"
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: selectedAccent = modelData
                    }
                }
            }
        }
        
        // Wallpaper selection
        Label { text: "Wallpaper"; font.weight: Font.Medium }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            
            RowLayout {
                spacing: 12
                
                Repeater {
                    model: [
                        { id: "default-dark", name: "Gati Night" },
                        { id: "default-light", name: "Gati Day" },
                        { id: "abstract-1", name: "Abstract" },
                        { id: "nature-1", name: "Nature" },
                        { id: "gradient-1", name: "Gradient" }
                    ]
                    
                    delegate: Rectangle {
                        width: 180; height: 120
                        radius: 8
                        color: Kirigami.Theme.alternateBackgroundColor
                        border.color: selectedWallpaper === modelData.id ? Kirigami.Theme.highlightColor : "transparent"
                        border.width: 3
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            Kirigami.Icon { source: "view-preview"; width: 48; height: 48; Layout.alignment: Qt.AlignHCenter; opacity: 0.5 }
                            Label { text: modelData.name; Layout.alignment: Qt.AlignHCenter }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: selectedWallpaper = modelData.id
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
