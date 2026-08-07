import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    
    readonly property color primaryColor: "#3949AB"
    readonly property color accentColor: "#536DFE"
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#9E9E9E"
    readonly property color cardBg: Qt.rgba(30/255, 30/255, 30/255, 0.85)
    readonly property color inputBg: "#2A2A2A"
    
    Image {
        id: background
        source: config.background || "assets/background.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }
    
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }
    
    // Clock
    ColumnLayout {
        anchors { top: parent.top; left: parent.left; margins: 40 }
        spacing: 4
        
        Text {
            text: Qt.formatTime(new Date(), "HH:mm")
            font { family: "Inter"; pixelSize: 56; weight: Font.Light }
            color: textPrimary
        }
        Text {
            text: Qt.formatDate(new Date(), "dddd, MMMM d")
            font { family: "Inter"; pixelSize: 18 }
            color: textSecondary
        }
    }
    
    // Login Card
    Rectangle {
        id: loginCard
        width: 380; height: 400
        anchors.centerIn: parent
        radius: 20
        color: cardBg
        
        ColumnLayout {
            anchors { fill: parent; margins: 40 }
            spacing: 16
            
            Image {
                source: "assets/logo.png"
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                Layout.alignment: Qt.AlignHCenter
                radius: 40
                color: primaryColor
                
                Text {
                    anchors.centerIn: parent
                    text: "U"
                    font { family: "Inter"; pixelSize: 32 }
                    color: textPrimary
                }
            }
            
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                echoMode: TextInput.Password
                placeholderText: "Password"
                
                background: Rectangle {
                    radius: 10
                    color: inputBg
                    border.color: passwordField.focus ? accentColor : "transparent"
                    border.width: 2
                }
                
                Keys.onReturnPressed: sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
            }
            
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                text: "Log In"
                
                background: Rectangle {
                    radius: 10
                    color: primaryColor
                }
                
                contentItem: Text {
                    text: "Log In"
                    color: textPrimary
                    horizontalAlignment: Text.AlignHCenter
                }
                
                onClicked: sddm.login(userModel.lastUser, passwordField.text, sessionModel.lastIndex)
            }
        }
    }
    
    // Power buttons
    Row {
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: 40 }
        spacing: 32
        
        Text { text: "⏻ Shutdown"; color: textSecondary; MouseArea { anchors.fill: parent; onClicked: sddm.powerOff() }}
        Text { text: "🔄 Restart"; color: textSecondary; MouseArea { anchors.fill: parent; onClicked: sddm.reboot() }}
    }
}
