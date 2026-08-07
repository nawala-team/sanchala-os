// OnlineAccountsPage.qml - Optional cloud accounts
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: accountsPage
    property var connectedAccounts: []
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Online Accounts"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Connect your accounts for calendar, contacts, and cloud storage"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "This step is optional. You can set this up later in Settings."
            font.pixelSize: 12
            opacity: 0.6
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Account providers
        Repeater {
            model: ListModel {
                ListElement { provider: "Google"; icon: "google"; services: "Calendar, Contacts, Drive" }
                ListElement { provider: "Microsoft"; icon: "microsoft"; services: "Outlook, OneDrive" }
                ListElement { provider: "Nextcloud"; icon: "nextcloud"; services: "Files, Calendar, Contacts" }
                ListElement { provider: "IMAP/SMTP"; icon: "mail-message"; services: "Email" }
            }
            
            delegate: Rectangle {
                Layout.fillWidth: true
                height: 72
                radius: 12
                color: Kirigami.Theme.alternateBackgroundColor
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    Rectangle {
                        width: 44; height: 44
                        radius: 8
                        color: Kirigami.Theme.backgroundColor
                        
                        Kirigami.Icon {
                            anchors.centerIn: parent
                            source: "user-identity"
                            width: 28; height: 28
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Label { text: model.provider; font.weight: Font.Medium }
                        Label { text: model.services; font.pixelSize: 12; opacity: 0.7 }
                    }
                    
                    Button {
                        text: connectedAccounts.indexOf(model.provider) >= 0 ? "Connected" : "Add"
                        highlighted: connectedAccounts.indexOf(model.provider) < 0
                        enabled: connectedAccounts.indexOf(model.provider) < 0
                        onClicked: {
                            // Would open OAuth flow
                            var newAccounts = connectedAccounts.slice()
                            newAccounts.push(model.provider)
                            connectedAccounts = newAccounts
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Privacy note
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 8
            color: Kirigami.Theme.alternateBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Kirigami.Icon { source: "security-high"; width: 20; height: 20 }
                Label {
                    text: "Your credentials are stored securely in the system keyring"
                    font.pixelSize: 12
                    opacity: 0.8
                }
            }
        }
    }
}
