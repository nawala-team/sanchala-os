// AllDonePage.qml - Setup complete celebration
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: allDonePage
    property int setupDuration: 245 // seconds
    
    // Confetti particles
    Repeater {
        model: 50
        Rectangle {
            id: confetti
            width: 8 + Math.random() * 8
            height: width
            radius: Math.random() > 0.5 ? width/2 : 0
            color: ["#3949AB", "#FFB300", "#00C853", "#E53935", "#8E24AA"][Math.floor(Math.random() * 5)]
            x: Math.random() * parent.width
            y: -50 - Math.random() * 200
            rotation: Math.random() * 360
            
            SequentialAnimation on y {
                loops: Animation.Infinite
                running: true
                NumberAnimation {
                    to: allDonePage.height + 50
                    duration: 2000 + Math.random() * 3000
                    easing.type: Easing.Linear
                }
                PropertyAction { value: -50 - Math.random() * 200 }
            }
            
            NumberAnimation on rotation {
                loops: Animation.Infinite
                from: 0; to: 360
                duration: 1000 + Math.random() * 2000
            }
            
            NumberAnimation on x {
                loops: Animation.Infinite
                from: confetti.x - 30
                to: confetti.x + 30
                duration: 500 + Math.random() * 1000
            }
        }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32
        
        // Animated checkmark
        Rectangle {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
            Layout.alignment: Qt.AlignHCenter
            radius: 60
            color: Kirigami.Theme.positiveBackgroundColor
            
            Kirigami.Icon {
                anchors.centerIn: parent
                source: "checkmark"
                width: 64; height: 64
                color: Kirigami.Theme.positiveTextColor
                
                scale: 0
                NumberAnimation on scale {
                    to: 1
                    duration: 500
                    easing.type: Easing.OutBack
                    running: true
                }
            }
        }
        
        Label {
            text: "You're All Set!"
            font.pixelSize: 36
            font.weight: Font.Bold
            Layout.alignment: Qt.AlignHCenter
            
            opacity: 0
            NumberAnimation on opacity { to: 1; duration: 600; running: true }
        }
        
        Label {
            text: "Welcome to Sanchala OS"
            font.pixelSize: 18
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Setup summary
        Rectangle {
            Layout.preferredWidth: 400
            Layout.preferredHeight: summaryCol.implicitHeight + 32
            Layout.alignment: Qt.AlignHCenter
            radius: 12
            color: Kirigami.Theme.alternateBackgroundColor
            
            ColumnLayout {
                id: summaryCol
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                Label { text: "Setup Summary"; font.weight: Font.Medium }
                Rectangle { Layout.fillWidth: true; height: 1; color: Kirigami.Theme.separatorColor }
                
                RowLayout {
                    Label { text: "\u23f1 Setup time:"; opacity: 0.7 }
                    Item { Layout.fillWidth: true }
                    Label { text: formatDuration(setupDuration); font.weight: Font.Medium }
                }
                RowLayout {
                    Label { text: "\ud83d\udee1 Security:"; opacity: 0.7 }
                    Item { Layout.fillWidth: true }
                    Label { text: "Protected"; color: Kirigami.Theme.positiveTextColor }
                }
                RowLayout {
                    Label { text: "\ud83d\udd12 Privacy:"; opacity: 0.7 }
                    Item { Layout.fillWidth: true }
                    Label { text: "100% Private"; color: Kirigami.Theme.positiveTextColor }
                }
            }
        }
        
        Item { height: 20 }
        
        // Quick actions
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            
            Button {
                text: "Open Settings"
                icon.name: "configure"
                flat: true
            }
            
            Button {
                text: "App Store"
                icon.name: "store"
                flat: true
            }
        }
    }
    
    function formatDuration(secs) {
        var mins = Math.floor(secs / 60)
        var s = secs % 60
        return mins + " min " + s + " sec"
    }
}
