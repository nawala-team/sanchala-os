import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: root
    
    Plasmoid.icon: "folder-cloud"
    Plasmoid.title: "Sanchala Cloud"
    Plasmoid.toolTipMainText: "Cloud Storage"
    Plasmoid.toolTipSubText: statusText
    
    property string statusText: "All synced"
    property var accounts: []
    
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: syncIcon
        active: mouseArea.containsMouse
        
        property string syncIcon: {
            if (syncing) return "cloud-syncing"
            if (hasError) return "cloud-error"
            return "cloud-synced"
        }
        property bool syncing: false
        property bool hasError: false
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }
    
    Plasmoid.fullRepresentation: ColumnLayout {
        Layout.minimumWidth: 300
        Layout.minimumHeight: 200
        
        PlasmaComponents.Label {
            text: "Cloud Accounts"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: accountModel
            delegate: accountDelegate
        }
        
        PlasmaComponents.Button {
            text: "Sync All"
            icon.name: "view-refresh"
            Layout.alignment: Qt.AlignHCenter
            onClicked: syncAll()
        }
    }
    
    ListModel { id: accountModel }
    
    Component {
        id: accountDelegate
        RowLayout {
            width: parent.width
            PlasmaCore.IconItem {
                source: model.icon
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
            }
            ColumnLayout {
                PlasmaComponents.Label { text: model.name }
                PlasmaComponents.Label { 
                    text: model.status
                    font.pointSize: 8
                    opacity: 0.7
                }
            }
            Item { Layout.fillWidth: true }
            PlasmaCore.IconItem {
                source: model.statusIcon
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
            }
        }
    }
    
    function syncAll() {
        // Call D-Bus to trigger sync
    }
    
    Component.onCompleted: {
        // Load accounts from daemon
    }
}
