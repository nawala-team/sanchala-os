import QtQuick 2.15

// Dolphin File Overlay Plugin for Sanchala Cloud
// Shows sync status icons on cloud-synced files

Item {
    id: overlay
    
    property string filePath: ""
    property string status: "synced"  // synced, syncing, pending, error, offline
    
    readonly property var statusIcons: ({
        "synced": "cloud-synced",
        "syncing": "cloud-syncing", 
        "pending": "cloud-pending",
        "error": "cloud-error",
        "offline": "cloud-offline"
    })
    
    Image {
        id: statusIcon
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 16
        height: 16
        source: "image://icon/" + statusIcons[status]
        visible: isCloudFile(filePath)
        
        SequentialAnimation on opacity {
            running: status === "syncing"
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }
    
    function isCloudFile(path) {
        return path.startsWith(Qt.resolvedUrl("file://" + StandardPaths.home + "/Cloud"))
    }
    
    // D-Bus connection to get file status
    Connections {
        target: cloudDaemon
        function onFileStatusChanged(path, newStatus) {
            if (path === filePath) {
                status = newStatus
            }
        }
    }
}
