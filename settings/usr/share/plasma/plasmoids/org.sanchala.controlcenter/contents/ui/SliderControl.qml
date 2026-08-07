/*
 * Sanchala Control Center - Slider Control Component
 * Reusable slider with icon and percentage display
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: root
    
    property string icon
    property string label
    property real value: 0.5
    property real from: 0
    property real to: 1
    
    signal valueChanged(real newValue)
    
    implicitHeight: 40
    
    RowLayout {
        anchors.fill: parent
        spacing: 12
        
        // Icon (clickable for mute/toggle)
        Rectangle {
            width: 32
            height: 32
            radius: 8
            color: Qt.rgba(Kirigami.Theme.textColor.r,
                          Kirigami.Theme.textColor.g,
                          Kirigami.Theme.textColor.b, 0.08)
            
            Kirigami.Icon {
                anchors.centerIn: parent
                source: root.icon
                width: 18
                height: 18
                color: Kirigami.Theme.textColor
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (slider.value > 0) {
                        slider.value = 0
                    } else {
                        slider.value = 0.75
                    }
                }
            }
        }
        
        // Slider
        Slider {
            id: slider
            Layout.fillWidth: true
            from: root.from
            to: root.to
            value: root.value
            
            onMoved: root.valueChanged(value)
            
            background: Rectangle {
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: slider.availableWidth
                height: 6
                radius: 3
                color: Qt.rgba(Kirigami.Theme.textColor.r,
                              Kirigami.Theme.textColor.g,
                              Kirigami.Theme.textColor.b, 0.15)
                
                Rectangle {
                    width: slider.visualPosition * parent.width
                    height: parent.height
                    radius: 3
                    color: Kirigami.Theme.highlightColor
                    
                    Behavior on width {
                        NumberAnimation { duration: 50 }
                    }
                }
            }
            
            handle: Rectangle {
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: 20
                height: 20
                radius: 10
                color: "white"
                
                // Shadow
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: 12
                        color: Qt.rgba(0, 0, 0, 0.2)
                    }
                }
                
                border.color: Qt.rgba(0, 0, 0, 0.1)
                border.width: 1
                
                scale: slider.pressed ? 1.1 : 1.0
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
        
        // Percentage label
        PlasmaComponents.Label {
            text: Math.round(slider.value * 100) + "%"
            font.pixelSize: 12
            font.weight: Font.Medium
            opacity: 0.8
            Layout.minimumWidth: 36
            horizontalAlignment: Text.AlignRight
        }
    }
}
