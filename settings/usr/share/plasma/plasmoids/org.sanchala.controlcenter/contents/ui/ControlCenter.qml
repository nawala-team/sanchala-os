/*
 * Sanchala Control Center - Full Representation
 * Main control center panel with toggles, sliders, and media
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami

PlasmaExtras.Representation {
    id: controlCenter
    
    property string expandedPanel: ""
    
    implicitWidth: 340
    implicitHeight: mainColumn.implicitHeight + 32
    
    // Background with blur
    Rectangle {
        anchors.fill: parent
        color: Kirigami.Theme.backgroundColor
        opacity: 0.95
        radius: 16
    }
    
    ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            // User Avatar
            Rectangle {
                width: 40; height: 40
                radius: 20
                color: Kirigami.Theme.highlightColor
                
                Text {
                    anchors.centerIn: parent
                    text: "S"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: "white"
                }
            }
            
            ColumnLayout {
                spacing: 2
                PlasmaComponents.Label {
                    text: i18n("Sanchala User")
                    font.weight: Font.Medium
                }
                PlasmaComponents.Label {
                    text: i18n("Active")
                    font.pixelSize: 11
                    opacity: 0.7
                }
            }
            
            Item { Layout.fillWidth: true }
            
            PlasmaComponents.ToolButton {
                icon.name: "configure"
                onClicked: Qt.openUrlExternally("systemsettings5")
            }
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.1
        }
        
        // Toggle Grid
        ToggleGrid {
            Layout.fillWidth: true
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.1
        }
        
        // Sliders Section
        SliderSection {
            Layout.fillWidth: true
        }
        
        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.1
        }
        
        // Media Player
        MediaWidget {
            Layout.fillWidth: true
        }
    }
}
