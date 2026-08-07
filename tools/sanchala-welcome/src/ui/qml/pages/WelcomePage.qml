// WelcomePage.qml - Initial welcome animation
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: welcomePage
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32
        
        // Animated logo
        Image {
            id: logo
            source: "qrc:/assets/sanchala-logo.svg"
            Layout.preferredWidth: 128
            Layout.preferredHeight: 128
            Layout.alignment: Qt.AlignHCenter
            
            // Fade in animation
            opacity: 0
            NumberAnimation on opacity {
                to: 1
                duration: 800
                easing.type: Easing.OutCubic
                running: true
            }
            
            // Gentle rotation
            RotationAnimation on rotation {
                from: -5
                to: 5
                duration: 3000
                loops: Animation.Infinite
                easing.type: Easing.InOutSine
            }
        }
        
        Label {
            text: "Welcome to Sanchala OS"
            font.pixelSize: 32
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
            
            opacity: 0
            NumberAnimation on opacity {
                to: 1
                duration: 600
                easing.type: Easing.OutCubic
                running: true
            }
        }
        
        Label {
            text: "Beautiful. Secure. Private."
            font.pixelSize: 18
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
            
            NumberAnimation on opacity {
                to: 0.7
                duration: 600
                running: true
            }
        }
        
        Item { height: 20 }
        
        Label {
            text: "Let's set up your new computer.\nThis will only take a few minutes."
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.8
        }
    }
}
