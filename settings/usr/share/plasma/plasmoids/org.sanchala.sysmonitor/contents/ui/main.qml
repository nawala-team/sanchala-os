/*
 * Sanchala System Monitor Widget
 * Real-time CPU, memory, and network monitoring
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright (C) 2026 Sanchala Team
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    property real cpuUsage: 0
    property real memUsage: 0
    property real netDown: 0
    property real netUp: 0
    
    Plasmoid.backgroundHints: PlasmaCore.Types.TranslucentBackground
    
    // Data source for system stats
    PlasmaCore.DataSource {
        id: sysMonitor
        engine: "systemmonitor"
        connectedSources: ["cpu/all/usage", "memory/physical/used", "memory/physical/total"]
        interval: 1000
        
        onNewData: (sourceName, data) => {
            if (sourceName === "cpu/all/usage") {
                cpuUsage = data.value || 0
            } else if (sourceName === "memory/physical/used") {
                var total = sysMonitor.data["memory/physical/total"]?.value || 1
                memUsage = (data.value / total) * 100
            }
        }
    }
    
    compactRepresentation: RowLayout {
        spacing: Kirigami.Units.smallSpacing
        
        Kirigami.Icon {
            source: "utilities-system-monitor"
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
        }
        
        PlasmaComponents.Label {
            text: Math.round(cpuUsage) + "%"
            font.pixelSize: Kirigami.Units.fontMetrics.font.pixelSize * 0.9
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }
    
    fullRepresentation: Rectangle {
        implicitWidth: 260
        implicitHeight: 180
        radius: 12
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r,
                       Kirigami.Theme.backgroundColor.g,
                       Kirigami.Theme.backgroundColor.b, 0.95)
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            
            // Header
            PlasmaComponents.Label {
                text: i18n("System Monitor")
                font.pixelSize: 14
                font.weight: Font.SemiBold
            }
            
            // CPU
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                
                RowLayout {
                    PlasmaComponents.Label { text: "CPU"; opacity: 0.7 }
                    Item { Layout.fillWidth: true }
                    PlasmaComponents.Label { text: Math.round(cpuUsage) + "%" }
                }
                
                PlasmaComponents.ProgressBar {
                    Layout.fillWidth: true
                    from: 0; to: 100
                    value: cpuUsage
                }
            }
            
            // Memory
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                
                RowLayout {
                    PlasmaComponents.Label { text: "Memory"; opacity: 0.7 }
                    Item { Layout.fillWidth: true }
                    PlasmaComponents.Label { text: Math.round(memUsage) + "%" }
                }
                
                PlasmaComponents.ProgressBar {
                    Layout.fillWidth: true
                    from: 0; to: 100
                    value: memUsage
                }
            }
            
            Item { Layout.fillHeight: true }
            
            // Open System Monitor button
            PlasmaComponents.Button {
                text: i18n("Open System Monitor")
                Layout.alignment: Qt.AlignHCenter
                onClicked: Qt.openUrlExternally("file:///usr/bin/plasma-systemmonitor")
            }
        }
    }
    
    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("System Monitor")
    toolTipSubText: i18n("CPU: %1% | Memory: %2%", Math.round(cpuUsage), Math.round(memUsage))
}
