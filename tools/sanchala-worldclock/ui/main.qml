import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    
    Plasmoid.icon: "clock"
    Plasmoid.title: "World Clock"
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    
    property var clocks: []
    
    Plasmoid.compactRepresentation: PlasmaComponents.Label {
        text: Qt.formatTime(new Date(), "HH:mm")
        font.bold: true
        font.pixelSize: 14
        MouseArea { anchors.fill: parent; onClicked: plasmoid.expanded = !plasmoid.expanded }
    }
    
    Plasmoid.fullRepresentation: ColumnLayout {
        Layout.preferredWidth: 280
        Layout.preferredHeight: 300
        spacing: 8
        
        PlasmaComponents.Label { text: "🌍 World Clock"; font.bold: true; font.pixelSize: 16; Layout.alignment: Qt.AlignHCenter }
        Rectangle { Layout.fillWidth: true; height: 1; color: PlasmaCore.Theme.textColor; opacity: 0.2 }
        
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: clocks
            spacing: 8
            delegate: RowLayout {
                width: parent.width
                PlasmaComponents.Label { text: "🕐"; font.pixelSize: 20 }
                ColumnLayout {
                    spacing: 0
                    PlasmaComponents.Label { text: modelData.city; font.bold: true }
                    PlasmaComponents.Label { text: modelData.time; font.pixelSize: 18 }
                }
                Item { Layout.fillWidth: true }
                PlasmaComponents.Label { text: modelData.offset; opacity: 0.6; font.pixelSize: 11 }
            }
        }
        
        PlasmaComponents.Button { text: "Settings"; Layout.alignment: Qt.AlignHCenter
            onClicked: executable.exec("sanchala-worldclock gui") }
    }
    
    Timer { interval: 1000; running: true; repeat: true; onTriggered: updateClocks() }
    Component.onCompleted: updateClocks()
    
    function updateClocks() {
        executable.exec("sanchala-worldclock show --json")
    }
    
    PlasmaCore.DataSource {
        id: executable; engine: "executable"
        onNewData: { try { clocks = JSON.parse(data["stdout"]) } catch(e) {}; disconnectSource(sourceName) }
        function exec(cmd) { connectSource(cmd) }
    }
}
