// NetworkPage.qml - Network configuration
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: networkPage
    property string selectedNetwork: ""
    property bool isConnecting: false
    property bool isConnected: false
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Connect to the Internet"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Choose a Wi-Fi network or connect via Ethernet"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Status bar
        Rectangle {
            Layout.fillWidth: true
            height: 56
            radius: 12
            color: isConnected ? Kirigami.Theme.positiveBackgroundColor : Kirigami.Theme.alternateBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                Kirigami.Icon {
                    source: isConnected ? "network-wireless-connected-100" : "network-wireless"
                    width: 28; height: 28
                }
                
                Label {
                    text: isConnected ? "Connected to " + selectedNetwork : 
                          isConnecting ? "Connecting..." : "Not connected"
                    font.weight: Font.Medium
                }
                
                Item { Layout.fillWidth: true }
                
                BusyIndicator { visible: isConnecting; running: isConnecting; width: 24; height: 24 }
                Kirigami.Icon { source: "checkmark"; visible: isConnected; width: 24; height: 24 }
            }
        }
        
        Label { text: "Wi-Fi Networks"; font.weight: Font.Medium }
        
        ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ListModel {
                ListElement { ssid: "HomeNetwork"; strength: 85; secured: true }
                ListElement { ssid: "Office-WiFi"; strength: 72; secured: true }
                ListElement { ssid: "CoffeeShop"; strength: 45; secured: false }
                ListElement { ssid: "Guest-Network"; strength: 30; secured: true }
            }
            
            delegate: ItemDelegate {
                width: networkList.width
                height: 56
                highlighted: model.ssid === selectedNetwork
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    
                    Kirigami.Icon {
                        source: model.strength > 60 ? "network-wireless-signal-excellent" :
                                model.strength > 30 ? "network-wireless-signal-good" :
                                "network-wireless-signal-weak"
                        width: 24; height: 24
                    }
                    
                    Label { text: model.ssid; font.weight: Font.Medium }
                    Label { text: model.secured ? "\ud83d\udd12" : ""; font.pixelSize: 14 }
                    Item { Layout.fillWidth: true }
                    Label { text: model.strength + "%"; opacity: 0.6 }
                }
                
                onClicked: {
                    selectedNetwork = model.ssid
                    if (model.secured) passwordDialog.open()
                    else connectNetwork()
                }
            }
        }
        
        RowLayout {
            Button { text: "Refresh"; icon.name: "view-refresh" }
            Item { Layout.fillWidth: true }
            Button { text: "Hidden Network..."; flat: true }
        }
    }
    
    Dialog {
        id: passwordDialog
        title: "Enter Password"
        modal: true
        anchors.centerIn: parent
        width: 360
        
        ColumnLayout {
            spacing: 16
            Label { text: "Password for \"" + selectedNetwork + "\"" }
            TextField {
                id: pwField
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Password"
            }
            CheckBox { text: "Show password"; onCheckedChanged: pwField.echoMode = checked ? TextInput.Normal : TextInput.Password }
        }
        
        standardButtons: Dialog.Cancel | Dialog.Ok
        onAccepted: connectNetwork()
    }
    
    function connectNetwork() {
        isConnecting = true
        connectTimer.start()
    }
    
    Timer {
        id: connectTimer
        interval: 1500
        onTriggered: { isConnecting = false; isConnected = true }
    }
}
