// RegionPage.qml - Timezone and regional settings
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: regionPage
    property string selectedTimezone: "UTC"
    property string selectedCountry: ""
    property string dateFormat: "YYYY-MM-DD"
    property bool use24Hour: true
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Where are you?"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Select your timezone and regional preferences"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Interactive Map placeholder
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            color: Kirigami.Theme.alternateBackgroundColor
            radius: 12
            
            Image {
                anchors.fill: parent
                anchors.margins: 8
                source: "qrc:/assets/world-map.svg"
                fillMode: Image.PreserveAspectFit
                opacity: 0.8
            }
            
            Label {
                anchors.centerIn: parent
                text: selectedCountry === "" ? "Click map or search below" : selectedTimezone
                opacity: 0.6
            }
        }
        
        // Search row
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            TextField {
                id: tzSearch
                Layout.fillWidth: true
                placeholderText: "Search timezone or city..."
            }
            
            Button {
                text: "Detect"
                icon.name: "gps"
                onClicked: { selectedTimezone = "Asia/Jakarta"; selectedCountry = "ID" }
            }
        }
        
        // Timezone list
        ListView {
            id: tzList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: ListModel {
                ListElement { tz: "America/New_York"; name: "New York"; offset: "UTC-5" }
                ListElement { tz: "Europe/London"; name: "London"; offset: "UTC+0" }
                ListElement { tz: "Asia/Tokyo"; name: "Tokyo"; offset: "UTC+9" }
                ListElement { tz: "Asia/Jakarta"; name: "Jakarta"; offset: "UTC+7" }
                ListElement { tz: "Australia/Sydney"; name: "Sydney"; offset: "UTC+11" }
            }
            
            delegate: ItemDelegate {
                width: tzList.width
                highlighted: model.tz === selectedTimezone
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    Label { text: model.name; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Label { text: model.offset; opacity: 0.6 }
                }
                onClicked: selectedTimezone = model.tz
            }
        }
        
        // Format preferences
        RowLayout {
            Layout.fillWidth: true
            spacing: 24
            
            Label { text: "Date:" }
            ComboBox {
                model: ["YYYY-MM-DD", "DD/MM/YYYY", "MM/DD/YYYY"]
                onCurrentTextChanged: dateFormat = currentText
            }
            
            Label { text: "Time:" }
            Switch {
                text: checked ? "24h" : "12h"
                checked: use24Hour
                onCheckedChanged: use24Hour = checked
            }
        }
    }
}
