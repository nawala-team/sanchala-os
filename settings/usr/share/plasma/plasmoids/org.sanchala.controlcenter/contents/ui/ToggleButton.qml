/*
 * Sanchala Control Center - Toggle Button Component
 * Individual toggle button with icon, label, and subtitle
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

Rectangle {
    id: root
    
    property string icon
    property string label
    property string subtitle: ""
    property bool active: false
    property bool expandable: false
    
    signal clicked()
    signal pressAndHold()
    
    Layout.fillWidth: true
    implicitWidth: 100
    implicitHeight: 72
    radius: 12
    
    color: active ? Kirigami.Theme.highlightColor 
                  : Qt.rgba(Kirigami.Theme.textColor.r,
                            Kirigami.Theme.textColor.g,
                            Kirigami.Theme.textColor.b, 0.08)
    
    Behavior on color {
        ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
    
    // Hover effect
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4
        
        Kirigami.Icon {
            source: root.icon
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 24
            implicitHeight: 24
            color: active ? "white" : Kirigami.Theme.textColor
            
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
        
        PlasmaComponents.Label {
            text: root.label
            font.pixelSize: 11
            font.weight: Font.Medium
            color: active ? "white" : Kirigami.Theme.textColor
            Layout.alignment: Qt.AlignHCenter
            
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
        
        PlasmaComponents.Label {
            text: root.subtitle
            font.pixelSize: 10
            opacity: 0.7
            color: active ? "white" : Kirigami.Theme.textColor
            Layout.alignment: Qt.AlignHCenter
            visible: subtitle.length > 0
            elide: Text.ElideRight
            Layout.maximumWidth: root.width - 16
            
            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
    
    // Expand indicator (small dot at bottom)
    Rectangle {
        visible: expandable
        width: 4
        height: 4
        radius: 2
        color: active ? "white" : Kirigami.Theme.textColor
        opacity: 0.5
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 6
        }
    }
    
    // Press animation
    scale: mouseArea.pressed ? 0.95 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }
}
