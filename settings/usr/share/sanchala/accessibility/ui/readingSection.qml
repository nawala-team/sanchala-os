// ============================================
// SANCHALA OS - Reading Assistance Section
// ============================================

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

ColumnLayout {
    spacing: Kirigami.Units.largeSpacing
    
    // Screen Magnifier
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Screen Magnifier:")
            text: i18n("Zoom in on screen content")
            checked: kcm.magnifier
            onToggled: kcm.magnifier = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Zoom Level:")
            enabled: kcm.magnifier
            
            Slider {
                from: 1.0
                to: 16.0
                stepSize: 0.5
                value: kcm.magnificationLevel
                onMoved: kcm.magnificationLevel = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.magnificationLevel.toFixed(1) + "x"
                Layout.minimumWidth: 40
            }
        }
        
        ComboBox {
            Kirigami.FormData.label: i18n("Magnifier Style:")
            enabled: kcm.magnifier
            model: [
                i18n("Full Screen"),
                i18n("Lens (follows cursor)"),
                i18n("Docked (top/bottom)")
            ]
            currentIndex: kcm.magnifierMode
            onCurrentIndexChanged: kcm.magnifierMode = currentIndex
        }
        
        ComboBox {
            Kirigami.FormData.label: i18n("Magnifier Follows:")
            enabled: kcm.magnifier
            model: [
                i18n("Mouse cursor"),
                i18n("Keyboard focus"),
                i18n("Text caret"),
                i18n("All of the above")
            ]
            currentIndex: kcm.magnifierFollows
            onCurrentIndexChanged: kcm.magnifierFollows = currentIndex
        }
        
        CheckBox {
            text: i18n("Invert colors in magnified area")
            enabled: kcm.magnifier
            checked: kcm.magnifierInvert
            onToggled: kcm.magnifierInvert = checked
            leftPadding: Kirigami.Units.gridUnit * 2
        }
        
        CheckBox {
            text: i18n("Show crosshair")
            enabled: kcm.magnifier
            checked: kcm.magnifierCrosshair
            onToggled: kcm.magnifierCrosshair = checked
            leftPadding: Kirigami.Units.gridUnit * 2
        }
        
        Label {
            text: i18n("Shortcuts: Super+= zoom in, Super+- zoom out, Super+0 reset")
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            color: Kirigami.Theme.disabledTextColor
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Reading Guide
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Reading Guide:")
            text: i18n("Highlight line under cursor")
            checked: kcm.readingGuide
            onToggled: kcm.readingGuide = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Guide Color:")
            enabled: kcm.readingGuide
            
            Rectangle {
                width: 24
                height: 24
                color: kcm.readingGuideColor
                border.color: Kirigami.Theme.textColor
                border.width: 1
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: colorDialog.open()
                }
            }
            
            Slider {
                from: 10
                to: 80
                value: kcm.readingGuideOpacity
                onMoved: kcm.readingGuideOpacity = value
                Layout.fillWidth: true
            }
            
            Label {
                text: kcm.readingGuideOpacity + "% opacity"
                Layout.minimumWidth: 80
            }
        }
    }
    
    Kirigami.Separator { Layout.fillWidth: true }
    
    // Focus Indicators
    Kirigami.FormLayout {
        Layout.fillWidth: true
        
        CheckBox {
            Kirigami.FormData.label: i18n("Enhanced Focus:")
            text: i18n("Show prominent focus indicators")
            checked: kcm.enhancedFocus
            onToggled: kcm.enhancedFocus = checked
        }
        
        RowLayout {
            Kirigami.FormData.label: i18n("Focus Ring Width:")
            enabled: kcm.enhancedFocus
            
            SpinBox {
                from: 1
                to: 6
                value: kcm.focusWidth
                onValueModified: kcm.focusWidth = value
            }
            
            Label { text: i18n("pixels") }
        }
    }
}
