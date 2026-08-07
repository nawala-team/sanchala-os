// ============================================
// SANCHALA OS - Mobility/Keyboard Section
// ============================================

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

ColumnLayout {
    spacing: Kirigami.Units.largeSpacing
    
    // Sticky Keys
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Sticky Keys:")
            text: i18n("Press modifier keys one at a time")
            checked: kcm.stickyKeys
            onToggled: kcm.stickyKeys = checked
        }
        
        CheckBox {
            text: i18n("Lock modifier when pressed twice")
            enabled: kcm.stickyKeys
            checked: kcm.stickyKeysLock
            onToggled: kcm.stickyKeysLock = checked
            leftPadding: Kirigami.Units.gridUnit * 2
        }
        
        CheckBox {
            text: i18n("Play sound when modifier is pressed")
            enabled: kcm.stickyKeys
            checked: kcm.stickyKeysSound
            onToggled: kcm.stickyKeysSound = checked
            leftPadding: Kirigami.Units.gridUnit * 2
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Slow Keys
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Slow Keys:")
            text: i18n("Ignore brief or repeated keystrokes")
            checked: kcm.slowKeys
            onToggled: kcm.slowKeys = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Acceptance Delay:")
            enabled: kcm.slowKeys
            
            Slider {
                from: 100
                to: 1000
                stepSize: 50
                value: kcm.slowKeysDelay
                onMoved: kcm.slowKeysDelay = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.slowKeysDelay + " ms"
                Layout.minimumWidth: 60
            }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Bounce Keys
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Bounce Keys:")
            text: i18n("Ignore fast duplicate keystrokes")
            checked: kcm.bounceKeys
            onToggled: kcm.bounceKeys = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Bounce Delay:")
            enabled: kcm.bounceKeys
            
            Slider {
                from: 100
                to: 1000
                stepSize: 50
                value: kcm.bounceKeysDelay
                onMoved: kcm.bounceKeysDelay = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.bounceKeysDelay + " ms"
                Layout.minimumWidth: 60
            }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Mouse Keys
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Mouse Keys:")
            text: i18n("Control pointer using numeric keypad")
            checked: kcm.mouseKeys
            onToggled: kcm.mouseKeys = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Pointer Speed:")
            enabled: kcm.mouseKeys
            
            Slider {
                from: 1
                to: 100
                value: kcm.mouseKeysSpeed
                onMoved: kcm.mouseKeysSpeed = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.mouseKeysSpeed
                Layout.minimumWidth: 30
            }
        }
        
        CheckBox {
            text: i18n("Enable acceleration")
            enabled: kcm.mouseKeys
            checked: kcm.mouseKeysAccel
            onToggled: kcm.mouseKeysAccel = checked
            leftPadding: Kirigami.Units.gridUnit * 2
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Dwell Click
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Dwell Click:")
            text: i18n("Click by hovering over items")
            checked: kcm.dwellClick
            onToggled: kcm.dwellClick = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Dwell Time:")
            enabled: kcm.dwellClick
            
            Slider {
                from: 200
                to: 3000
                stepSize: 100
                value: kcm.dwellTime
                onMoved: kcm.dwellTime = value
                Layout.fillWidth: true
            }
            
            Label {
                text: (kcm.dwellTime / 1000).toFixed(1) + " s"
                Layout.minimumWidth: 40
            }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // On-Screen Keyboard
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("On-Screen Keyboard:")
            text: i18n("Show virtual keyboard when needed")
            checked: kcm.onScreenKeyboard
            onToggled: kcm.onScreenKeyboard = checked
        }
    }
}
