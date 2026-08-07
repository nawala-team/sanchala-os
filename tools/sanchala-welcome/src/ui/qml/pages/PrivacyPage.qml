// PrivacyPage.qml - Privacy settings (all OFF by default)
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: privacyPage
    
    // Privacy-first: ALL OFF by default
    property bool telemetryEnabled: false
    property bool crashReportsEnabled: false
    property bool locationEnabled: false
    property bool analyticsEnabled: false
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Privacy Settings"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Your privacy is our priority. All options are OFF by default."
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Privacy score
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 12
            color: Kirigami.Theme.positiveBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                Rectangle {
                    width: 56; height: 56
                    radius: 28
                    color: Kirigami.Theme.positiveTextColor
                    
                    Label {
                        anchors.centerIn: parent
                        text: privacyScore + "%"
                        font.pixelSize: 18
                        font.bold: true
                        color: "white"
                    }
                }
                
                ColumnLayout {
                    spacing: 4
                    Label { text: "Privacy Score: Excellent"; font.weight: Font.Bold }
                    Label { text: "No data is shared with anyone"; opacity: 0.8 }
                }
            }
        }
        
        // Privacy options
        Repeater {
            model: ListModel {
                ListElement {
                    title: "Usage Statistics"
                    desc: "Anonymous data about feature usage to improve Sanchala OS"
                    icon: "office-chart-bar"
                    propName: "telemetryEnabled"
                }
                ListElement {
                    title: "Crash Reports"
                    desc: "Send crash reports to help fix bugs (no personal data)"
                    icon: "tools-report-bug"
                    propName: "crashReportsEnabled"
                }
                ListElement {
                    title: "Location Services"
                    desc: "Allow apps to request your location (per-app control)"
                    icon: "find-location"
                    propName: "locationEnabled"
                }
                ListElement {
                    title: "Analytics"
                    desc: "Help improve Sanchala by sharing system analytics"
                    icon: "view-statistics"
                    propName: "analyticsEnabled"
                }
            }
            
            delegate: Rectangle {
                Layout.fillWidth: true
                height: 72
                radius: 8
                color: Kirigami.Theme.alternateBackgroundColor
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    Kirigami.Icon { source: model.icon; width: 32; height: 32 }
                    
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true
                        Label { text: model.title; font.weight: Font.Medium }
                        Label { text: model.desc; font.pixelSize: 12; opacity: 0.7; wrapMode: Text.WordWrap }
                    }
                    
                    Switch {
                        checked: {
                            if (model.propName === "telemetryEnabled") return telemetryEnabled
                            if (model.propName === "crashReportsEnabled") return crashReportsEnabled
                            if (model.propName === "locationEnabled") return locationEnabled
                            if (model.propName === "analyticsEnabled") return analyticsEnabled
                            return false
                        }
                        onCheckedChanged: {
                            if (model.propName === "telemetryEnabled") telemetryEnabled = checked
                            else if (model.propName === "crashReportsEnabled") crashReportsEnabled = checked
                            else if (model.propName === "locationEnabled") locationEnabled = checked
                            else if (model.propName === "analyticsEnabled") analyticsEnabled = checked
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Transparency note
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 8
            color: Kirigami.Theme.alternateBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                Kirigami.Icon { source: "dialog-information"; width: 20; height: 20 }
                Label {
                    text: "You can change these settings anytime in Privacy Dashboard"
                    font.pixelSize: 12
                    opacity: 0.8
                }
            }
        }
    }
    
    property int privacyScore: {
        var score = 100
        if (telemetryEnabled) score -= 15
        if (crashReportsEnabled) score -= 10
        if (locationEnabled) score -= 15
        if (analyticsEnabled) score -= 10
        return score
    }
}
