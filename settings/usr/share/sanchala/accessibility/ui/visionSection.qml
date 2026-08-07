// ============================================
// SANCHALA OS - Vision Accessibility Section
// ============================================

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

ColumnLayout {
    spacing: Kirigami.Units.largeSpacing
    
    // Screen Reader
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        RowLayout {
            Kirigami.FormData.label: i18n("Screen Reader (Orca):")
            
            Switch {
                id: screenReaderSwitch
                checked: kcm.screenReaderEnabled
                onToggled: kcm.screenReaderEnabled = checked
            }
            
            Label {
                text: screenReaderSwitch.checked ? i18n("Running") : i18n("Off")
                color: screenReaderSwitch.checked ? Kirigami.Theme.positiveTextColor : Kirigami.Theme.disabledTextColor
            }
            
            Button {
                text: i18n("Configure...")
                icon.name: "configure"
                onClicked: kcm.openOrcaSettings()
            }
        }
        
        Label {
            text: i18n("Shortcut: Alt+Super+S")
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            color: Kirigami.Theme.disabledTextColor
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // High Contrast
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        ComboBox {
            Kirigami.FormData.label: i18n("High Contrast:")
            model: [
                i18n("Off"),
                i18n("High Contrast Light"),
                i18n("High Contrast Dark"),
                i18n("Inverted Colors")
            ]
            currentIndex: kcm.highContrastMode
            onCurrentIndexChanged: kcm.highContrastMode = currentIndex
        }
        
        CheckBox {
            text: i18n("Reduce transparency")
            checked: kcm.reduceTransparency
            onToggled: kcm.reduceTransparency = checked
        }
        
        CheckBox {
            text: i18n("Remove background images")
            checked: kcm.removeBackgrounds
            onToggled: kcm.removeBackgrounds = checked
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Text Size
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Large Text:")
            text: i18n("Enable larger text throughout the system")
            checked: kcm.largeText
            onToggled: kcm.largeText = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Text Scale:")
            enabled: kcm.largeText
            
            Slider {
                id: fontScaleSlider
                from: 1.0
                to: 2.5
                stepSize: 0.25
                value: kcm.fontScale
                onMoved: kcm.fontScale = value
                Layout.fillWidth: true
            }
            
            Label {
                text: Math.round(fontScaleSlider.value * 100) + "%"
                Layout.minimumWidth: 50
            }
        }
        
        CheckBox {
            text: i18n("Bold text for better readability")
            checked: kcm.boldText
            onToggled: kcm.boldText = checked
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Cursor
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Large Cursor:")
            text: i18n("Use a larger mouse cursor")
            checked: kcm.largeCursor
            onToggled: kcm.largeCursor = checked
        }
        
        ComboBox {
            Kirigami.FormData.label: i18n("Cursor Size:")
            enabled: kcm.largeCursor
            model: ["24px", "32px", "48px", "64px", "96px"]
            currentIndex: kcm.cursorSizeIndex
            onCurrentIndexChanged: kcm.cursorSizeIndex = currentIndex
        }
        
        CheckBox {
            text: i18n("Locate cursor when pressing Ctrl")
            checked: kcm.locateCursor
            onToggled: kcm.locateCursor = checked
        }
        
        CheckBox {
            text: i18n("Show cursor halo")
            checked: kcm.cursorHalo
            onToggled: kcm.cursorHalo = checked
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Color Filters
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        ComboBox {
            Kirigami.FormData.label: i18n("Color Filter:")
            model: [
                i18n("None"),
                i18n("Red-Green (Protanopia)"),
                i18n("Red-Green (Deuteranopia)"),
                i18n("Blue-Yellow (Tritanopia)"),
                i18n("Grayscale")
            ]
            currentIndex: kcm.colorFilter
            onCurrentIndexChanged: kcm.colorFilter = currentIndex
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Filter Intensity:")
            enabled: kcm.colorFilter > 0
            
            Slider {
                from: 0
                to: 100
                value: kcm.colorFilterIntensity
                onMoved: kcm.colorFilterIntensity = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.colorFilterIntensity + "%"
                Layout.minimumWidth: 40
            }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Motion
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Reduce Motion:")
            text: i18n("Minimize animations and transitions")
            checked: kcm.reduceMotion
            onToggled: kcm.reduceMotion = checked
        }
    }
}
