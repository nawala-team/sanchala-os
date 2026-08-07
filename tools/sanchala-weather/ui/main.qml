import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    
    Plasmoid.icon: "weather-clear"
    Plasmoid.title: "Sanchala Weather"
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    
    property var weatherData: ({temp: "--", condition: "Loading...", icon: "weather-none-available"})
    
    Plasmoid.compactRepresentation: RowLayout {
        spacing: 4
        PlasmaCore.IconItem { source: weatherData.icon; Layout.preferredWidth: 24; Layout.preferredHeight: 24 }
        PlasmaComponents.Label { text: weatherData.temp + "°"; font.bold: true }
        MouseArea { anchors.fill: parent; onClicked: plasmoid.expanded = !plasmoid.expanded }
    }
    
    Plasmoid.fullRepresentation: ColumnLayout {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 350
        spacing: 12
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            PlasmaCore.IconItem { source: weatherData.icon; Layout.preferredWidth: 64; Layout.preferredHeight: 64 }
            ColumnLayout {
                PlasmaComponents.Label { text: weatherData.temp + "°"; font.pixelSize: 36; font.bold: true }
                PlasmaComponents.Label { text: weatherData.condition; opacity: 0.8 }
            }
        }
        
        Rectangle { Layout.fillWidth: true; height: 1; color: PlasmaCore.Theme.textColor; opacity: 0.2 }
        
        // Details
        GridLayout { columns: 2; Layout.fillWidth: true; rowSpacing: 8; columnSpacing: 20
            PlasmaComponents.Label { text: "💧 Humidity"; opacity: 0.7 }
            PlasmaComponents.Label { text: weatherData.humidity || "--%" }
            PlasmaComponents.Label { text: "💨 Wind"; opacity: 0.7 }
            PlasmaComponents.Label { text: weatherData.wind || "-- km/h" }
            PlasmaComponents.Label { text: "☀️ UV Index"; opacity: 0.7 }
            PlasmaComponents.Label { text: weatherData.uv || "--" }
        }
        
        Item { Layout.fillHeight: true }
        
        PlasmaComponents.Button { text: "Open Weather"; Layout.alignment: Qt.AlignHCenter
            onClicked: Qt.openUrlExternally("sanchala-weather") }
    }
    
    Timer { interval: 1800000; running: true; repeat: true; onTriggered: updateWeather() }
    Component.onCompleted: updateWeather()
    
    function updateWeather() {
        executable.exec("sanchala-weather current --json")
    }
    
    PlasmaCore.DataSource {
        id: executable; engine: "executable"
        onNewData: {
            try { weatherData = JSON.parse(data["stdout"]) } catch(e) {}
            disconnectSource(sourceName)
        }
        function exec(cmd) { connectSource(cmd) }
    }
}
