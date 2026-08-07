/*
 * Sanchala Control Center - Toggle Grid
 * 3x2 grid of quick toggle buttons
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.networkmanagement as NM

GridLayout {
    id: toggleGrid
    
    columns: 3
    rowSpacing: 8
    columnSpacing: 8
    
    // WiFi Toggle
    ToggleButton {
        id: wifiToggle
        icon: wifiHandler.wifiEnabled ? "network-wireless" : "network-wireless-off"
        label: i18n("Wi-Fi")
        subtitle: wifiHandler.activeConnection || i18n("Off")
        active: wifiHandler.wifiEnabled
        expandable: true
        
        onClicked: wifiHandler.wifiEnabled = !wifiHandler.wifiEnabled
        onPressAndHold: expandedPanel = "wifi"
        
        NM.Handler {
            id: wifiHandler
        }
    }
    
    // Bluetooth Toggle
    ToggleButton {
        id: btToggle
        icon: btEnabled ? "bluetooth-active" : "bluetooth-disabled"
        label: i18n("Bluetooth")
        subtitle: btEnabled ? i18n("On") : i18n("Off")
        active: btEnabled
        expandable: true
        
        property bool btEnabled: true
        
        onClicked: btEnabled = !btEnabled
        onPressAndHold: expandedPanel = "bluetooth"
    }
    
    // Do Not Disturb Toggle
    ToggleButton {
        id: dndToggle
        icon: dndEnabled ? "notifications-disabled" : "notifications"
        label: i18n("DND")
        subtitle: dndEnabled ? i18n("On") : i18n("Off")
        active: dndEnabled
        
        property bool dndEnabled: false
        
        onClicked: dndEnabled = !dndEnabled
    }
    
    // Dark Mode Toggle
    ToggleButton {
        id: darkToggle
        icon: isDark ? "weather-clear-night" : "weather-clear"
        label: i18n("Dark Mode")
        subtitle: isDark ? i18n("On") : i18n("Off")
        active: isDark
        
        property bool isDark: Kirigami.Theme.backgroundColor.hslLightness < 0.5
        
        onClicked: {
            // Toggle theme via sanchala-theme-switch
            executable.exec("sanchala-theme-switch toggle")
        }
    }
    
    // Screen Cast Toggle
    ToggleButton {
        id: castToggle
        icon: "view-media-visualization"
        label: i18n("Screen Cast")
        subtitle: i18n("Off")
        active: false
        expandable: true
        
        onClicked: active = !active
        onPressAndHold: expandedPanel = "cast"
    }
    
    // Focus Mode Toggle
    ToggleButton {
        id: focusToggle
        icon: "preferences-desktop-activities"
        label: i18n("Focus")
        subtitle: focusMode
        active: focusMode !== "Off"
        expandable: true
        
        property string focusMode: "Off"
        property var modes: ["Off", "Work", "Personal", "Sleep"]
        
        onClicked: {
            var idx = modes.indexOf(focusMode)
            focusMode = modes[(idx + 1) % modes.length]
        }
        onPressAndHold: expandedPanel = "focus"
    }
    
    // Helper for executing commands
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        
        function exec(cmd) {
            connectSource(cmd)
        }
        
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName)
        }
    }
}
