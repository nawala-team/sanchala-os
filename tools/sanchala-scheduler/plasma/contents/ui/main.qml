// SPDX-License-Identifier: GPL-3.0
// Sanchala Scheduler - Plasma Widget for Task Status

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    preferredRepresentation: compactRepresentation
    
    compactRepresentation: Kirigami.Icon {
        source: "chronometer"
        active: mouseArea.containsMouse
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
        
        PlasmaComponents.ToolTip {
            text: i18n("Task Scheduler - %1 active tasks", taskCount)
        }
    }
    
    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20
        Layout.preferredHeight: Kirigami.Units.gridUnit * 15
        
        PlasmaComponents.Label {
            text: i18n("Scheduled Tasks")
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
        
        ListView {
            id: taskListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: schedulerModel
            clip: true
            
            delegate: PlasmaComponents.ItemDelegate {
                width: taskListView.width
                
                contentItem: RowLayout {
                    Kirigami.Icon {
                        source: model.active ? "task-complete" : "task-reject"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    }
                    
                    ColumnLayout {
                        spacing: 0
                        PlasmaComponents.Label {
                            text: model.name
                            elide: Text.ElideRight
                        }
                        PlasmaComponents.Label {
                            text: model.nextRun
                            font.pointSize: Kirigami.Theme.smallFont.pointSize
                            opacity: 0.7
                        }
                    }
                }
                
                onClicked: scheduler.runTask(model.name)
            }
            
            PlasmaComponents.Label {
                anchors.centerIn: parent
                visible: taskListView.count === 0
                text: i18n("No scheduled tasks")
                opacity: 0.6
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            
            PlasmaComponents.Button {
                text: i18n("Add Task")
                icon.name: "list-add"
                onClicked: Qt.openUrlExternally("kcm:kcm_sanchala_scheduler")
            }
            
            PlasmaComponents.Button {
                text: i18n("Settings")
                icon.name: "configure"
                onClicked: Qt.openUrlExternally("kcm:kcm_sanchala_scheduler")
            }
        }
    }
    
    property int taskCount: schedulerModel.count
    
    ListModel {
        id: schedulerModel
    }
    
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: refreshTasks()
    }
    
    Component.onCompleted: refreshTasks()
    
    function refreshTasks() {
        // Call sanchala-scheduler to get tasks
        scheduler.refresh()
    }
}
