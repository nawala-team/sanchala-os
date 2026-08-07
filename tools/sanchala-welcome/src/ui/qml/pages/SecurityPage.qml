// SecurityPage.qml - Security configuration
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: securityPage
    property bool firewallEnabled: true
    property bool diskEncrypted: false
    property bool secureBootEnabled: false
    property bool fingerprintAvailable: false
    property bool fingerprintEnrolled: false
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Security Settings"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Configure your system security"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Security status card
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 12
            color: Kirigami.Theme.positiveBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                Kirigami.Icon { source: "security-high"; width: 48; height: 48 }
                
                ColumnLayout {
                    spacing: 4
                    Label { text: "Your system is secure"; font.weight: Font.Bold }
                    Label { text: "Sanchala OS includes 8 layers of protection"; opacity: 0.8 }
                }
            }
        }
        
        // Security options
        GroupBox {
            Layout.fillWidth: true
            title: "System Protection"
            
            ColumnLayout {
                spacing: 16
                
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Label { text: "Firewall"; font.weight: Font.Medium }
                        Label { text: "Block unauthorized network access"; font.pixelSize: 12; opacity: 0.7 }
                    }
                    Item { Layout.fillWidth: true }
                    Switch { checked: firewallEnabled; onCheckedChanged: firewallEnabled = checked }
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: Kirigami.Theme.separatorColor }
                
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Label { text: "Secure Boot"; font.weight: Font.Medium }
                        Label { text: secureBootEnabled ? "Enabled in firmware" : "Not available"; font.pixelSize: 12; opacity: 0.7 }
                    }
                    Item { Layout.fillWidth: true }
                    Kirigami.Icon {
                        source: secureBootEnabled ? "checkmark" : "dialog-warning"
                        width: 24; height: 24
                    }
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: Kirigami.Theme.separatorColor }
                
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 2
                        Label { text: "Disk Encryption"; font.weight: Font.Medium }
                        Label { text: diskEncrypted ? "LUKS encryption active" : "Not encrypted"; font.pixelSize: 12; opacity: 0.7 }
                    }
                    Item { Layout.fillWidth: true }
                    Kirigami.Icon {
                        source: diskEncrypted ? "lock" : "unlock"
                        width: 24; height: 24
                    }
                }
            }
        }
        
        // Biometrics
        GroupBox {
            Layout.fillWidth: true
            title: "Biometric Authentication"
            visible: fingerprintAvailable
            
            ColumnLayout {
                spacing: 16
                
                RowLayout {
                    Kirigami.Icon { source: "fingerprint"; width: 32; height: 32 }
                    ColumnLayout {
                        spacing: 2
                        Label { text: "Fingerprint Sensor Detected"; font.weight: Font.Medium }
                        Label { text: fingerprintEnrolled ? "1 fingerprint enrolled" : "No fingerprints enrolled"; font.pixelSize: 12; opacity: 0.7 }
                    }
                    Item { Layout.fillWidth: true }
                    Button {
                        text: fingerprintEnrolled ? "Manage" : "Set Up"
                        onClicked: fingerprintDialog.open()
                    }
                }
            }
        }
        
        // No biometrics message
        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: 8
            color: Kirigami.Theme.alternateBackgroundColor
            visible: !fingerprintAvailable
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                Kirigami.Icon { source: "fingerprint"; width: 24; height: 24; opacity: 0.5 }
                Label { text: "No biometric hardware detected"; opacity: 0.7 }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
    
    Dialog {
        id: fingerprintDialog
        title: "Fingerprint Setup"
        modal: true
        anchors.centerIn: parent
        width: 400
        
        ColumnLayout {
            spacing: 24
            anchors.fill: parent
            
            Kirigami.Icon { source: "fingerprint"; Layout.preferredWidth: 64; Layout.preferredHeight: 64; Layout.alignment: Qt.AlignHCenter }
            Label { text: "Place your finger on the sensor"; Layout.alignment: Qt.AlignHCenter }
            ProgressBar { Layout.fillWidth: true; value: 0.3 }
            Label { text: "Lift and place your finger again (3/5)"; opacity: 0.7; Layout.alignment: Qt.AlignHCenter }
        }
        
        standardButtons: Dialog.Cancel
    }
    
    Component.onCompleted: {
        // Would detect actual hardware
        fingerprintAvailable = true
        secureBootEnabled = true
        diskEncrypted = true
    }
}
