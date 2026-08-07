/*
 * Sanchala Control Center - Compact Icon
 * System tray icon representation
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: compactRoot
    
    Kirigami.Icon {
        id: icon
        anchors.fill: parent
        source: "preferences-system"
        active: mouseArea.containsMouse
        
        // Smooth hover animation
        scale: mouseArea.containsMouse ? 1.1 : 1.0
        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded
    }
}
