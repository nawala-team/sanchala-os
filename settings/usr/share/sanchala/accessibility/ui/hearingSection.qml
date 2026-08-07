// ============================================
// SANCHALA OS - Hearing Accessibility Section
// ============================================

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

ColumnLayout {
    spacing: Kirigami.Units.largeSpacing
    
    // Visual Alerts
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Visual Alerts:")
            text: i18n("Flash screen when sounds occur")
            checked: kcm.visualAlerts
            onToggled: kcm.visualAlerts = checked
        }
        
        ComboBox {
            Kirigami.FormData.label: i18n("Flash Type:")
            enabled: kcm.visualAlerts
            model: [
                i18n("Flash entire screen"),
                i18n("Flash active window"),
                i18n("Flash window title bar")
            ]
            currentIndex: kcm.visualAlertType
            onCurrentIndexChanged: kcm.visualAlertType = currentIndex
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Audio Settings
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Mono Audio:")
            text: i18n("Combine left and right audio channels")
            checked: kcm.monoAudio
            onToggled: kcm.monoAudio = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Audio Balance:")
            
            Label { text: i18n("L") }
            
            Slider {
                from: -100
                to: 100
                value: kcm.audioBalance
                onMoved: kcm.audioBalance = value
                Layout.fillWidth: true
            }
            
            Label { text: i18n("R") }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Captions
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Captions:")
            text: i18n("Prefer captions and subtitles when available")
            checked: kcm.preferCaptions
            onToggled: kcm.preferCaptions = checked
        }
    }
}
