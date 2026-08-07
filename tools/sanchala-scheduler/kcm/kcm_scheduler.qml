// SPDX-License-Identifier: GPL-3.0
// Sanchala Scheduler KCM - Task Scheduler Settings Module

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root
    title: i18n("Task Scheduler")
    
    Kirigami.FormLayout {
        id: form
        
        Kirigami.Heading {
            text: i18n("Scheduled Tasks")
            level: 2
        }
        
        ListView {
            id: taskList
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            model: taskModel
            clip: true
            
            delegate: Kirigami.SwipeListItem {
                contentItem: RowLayout {
                    Kirigami.Icon {
                        source: model.enabled ? "task-complete" : "task-reject"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                    }
                    ColumnLayout {
                        spacing: 0
                        Layout.fillWidth: true
                        Label { text: model.name; font.bold: true }
                        Label { text: model.schedule; opacity: 0.7 }
                    }
                    Label { text: model.nextRun; opacity: 0.6 }
                }
                
                actions: [
                    Kirigami.Action {
                        icon.name: model.enabled ? "media-playback-pause" : "media-playback-start"
                        onTriggered: taskManager.toggleTask(model.name)
                    },
                    Kirigami.Action {
                        icon.name: "media-playback-start"
                        text: i18n("Run")
                        onTriggered: taskManager.runTask(model.name)
                    },
                    Kirigami.Action {
                        icon.name: "edit-delete"
                        onTriggered: taskManager.removeTask(model.name)
                    }
                ]
            }
            
            Kirigami.PlaceholderMessage {
                anchors.centerIn: parent
                visible: taskList.count === 0
                text: i18n("No scheduled tasks")
            }
        }
        
        Button {
            text: i18n("Add New Task")
            icon.name: "list-add"
            onClicked: addTaskSheet.open()
        }
        
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Quick Setup")
        }
        
        RowLayout {
            Button {
                text: i18n("Auto Backup")
                icon.name: "backup"
                onClicked: taskManager.quickBackup("03:00")
            }
            Button {
                text: i18n("Auto Cleanup")
                icon.name: "trash-empty"
                onClicked: taskManager.quickCleanup()
            }
        }
        
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("System Maintenance")
        }
        
        Switch {
            Kirigami.FormData.label: i18n("SSD TRIM (weekly):")
            checked: settings.trimEnabled
            onToggled: settings.trimEnabled = checked
        }
        
        Switch {
            Kirigami.FormData.label: i18n("Cache Cleanup (monthly):")
            checked: settings.cacheCleanupEnabled
            onToggled: settings.cacheCleanupEnabled = checked
        }
    }
    
    ListModel { id: taskModel }
    Component.onCompleted: refreshTasks()
    function refreshTasks() { /* Load from backend */ }
}
