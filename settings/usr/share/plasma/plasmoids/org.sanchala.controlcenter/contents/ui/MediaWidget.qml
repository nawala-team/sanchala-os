/*
 * Sanchala Control Center - Media Widget
 * Now Playing widget with MPRIS integration
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.20 as Kirigami

Rectangle {
    id: mediaWidget
    
    property bool hasMedia: true  // TODO: Connect to MPRIS
    property string title: "No Media Playing"
    property string artist: ""
    property string albumArt: ""
    property bool isPlaying: false
    
    visible: hasMedia
    implicitHeight: hasMedia ? 80 : 0
    radius: 12
    color: Qt.rgba(Kirigami.Theme.textColor.r,
                   Kirigami.Theme.textColor.g,
                   Kirigami.Theme.textColor.b, 0.05)
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        // Album Art
        Rectangle {
            width: 56
            height: 56
            radius: 8
            color: Kirigami.Theme.highlightColor
            
            Kirigami.Icon {
                anchors.centerIn: parent
                source: "media-album-cover"
                width: 32
                height: 32
                color: "white"
                visible: albumArt === ""
            }
            
            Image {
                anchors.fill: parent
                source: albumArt
                visible: albumArt !== ""
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: Item {
                    Rectangle {
                        anchors.fill: parent
                        radius: 8
                    }
                }
            }
        }
        
        // Title and Artist
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            
            PlasmaComponents.Label {
                text: title || i18n("No Media Playing")
                font.pixelSize: 13
                font.weight: Font.SemiBold
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            
            PlasmaComponents.Label {
                text: artist
                font.pixelSize: 11
                opacity: 0.7
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: artist !== ""
            }
            
            // Playback Controls
            RowLayout {
                spacing: 8
                Layout.topMargin: 4
                
                PlasmaComponents.ToolButton {
                    icon.name: "media-skip-backward"
                    icon.width: 16
                    icon.height: 16
                    onClicked: console.log("Previous")
                }
                
                PlasmaComponents.ToolButton {
                    icon.name: isPlaying ? "media-playback-pause" : "media-playback-start"
                    icon.width: 20
                    icon.height: 20
                    onClicked: isPlaying = !isPlaying
                }
                
                PlasmaComponents.ToolButton {
                    icon.name: "media-skip-forward"
                    icon.width: 16
                    icon.height: 16
                    onClicked: console.log("Next")
                }
            }
        }
    }
    
    Behavior on implicitHeight {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
}
