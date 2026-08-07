/*
 * Sanchala Control Center - Slider Section
 * Volume and Brightness sliders
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

ColumnLayout {
    id: sliderSection
    spacing: 16
    
    // Volume Slider
    SliderControl {
        Layout.fillWidth: true
        icon: volumeSlider.value === 0 ? "audio-volume-muted" 
              : volumeSlider.value < 0.3 ? "audio-volume-low"
              : volumeSlider.value < 0.7 ? "audio-volume-medium"
              : "audio-volume-high"
        label: i18n("Volume")
        value: 0.75
        
        onValueChanged: function(newValue) {
            // Connect to PipeWire/PulseAudio
            console.log("Volume:", Math.round(newValue * 100) + "%")
        }
    }
    
    // Brightness Slider
    SliderControl {
        Layout.fillWidth: true
        icon: brightnessSlider.value < 0.3 ? "brightness-low"
              : brightnessSlider.value < 0.7 ? "brightness-medium"
              : "brightness-high"
        label: i18n("Brightness")
        value: 0.60
        
        onValueChanged: function(newValue) {
            // Connect to PowerDevil
            console.log("Brightness:", Math.round(newValue * 100) + "%")
        }
    }
}
