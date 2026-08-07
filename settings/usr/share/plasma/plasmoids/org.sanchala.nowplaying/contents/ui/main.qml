/*
 * Sanchala Now Playing Widget
 * Standalone media player widget with MPRIS integration
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    property bool hasMedia: mpris.hasPlayer
    property string title: mpris.title || i18n("No Media")
    property string artist: mpris.artist || ""
    property string album: mpris.album || ""
    property string albumArt: mpris.artUrl || ""
    property bool isPlaying: mpris.playbackStatus === "Playing"
    property real position: mpris.position
    property real duration: mpris.length
    
    Plasmoid.backgroundHints: PlasmaCore.Types.TranslucentBackground
    
    // MPRIS Data Source
    PlasmaCore.DataSource {
        id: mpris
        engine: "mpris2"
        connectedSources: sources
        
        property string title: data[currentSource]?.Metadata?.["xesam:title"] ?? ""
        property string artist: data[currentSource]?.Metadata?.["xesam:artist"]?.[0] ?? ""
        property string album: data[currentSource]?.Metadata?.["xesam:album"] ?? ""
        property string artUrl: data[currentSource]?.Metadata?.["mpris:artUrl"] ?? ""
        property string playbackStatus: data[currentSource]?.PlaybackStatus ?? "Stopped"
        property real position: data[currentSource]?.Position ?? 0
        property real length: data[currentSource]?.Metadata?.["mpris:length"] ?? 0
        property bool hasPlayer: sources.length > 0
        property string currentSource: sources[0] || ""
        
        function action(name) {
            var service = serviceForSource(currentSource)
            var operation = service.operationDescription(name)
            service.startOperationCall(operation)
        }
    }
    
    fullRepresentation: Rectangle {
        implicitWidth: 280
        implicitHeight: 140
        radius: 16
        color: Qt.rgba(Kirigami.Theme.backgroundColor.r,
                       Kirigami.Theme.backgroundColor.g,
                       Kirigami.Theme.backgroundColor.b, 0.95)
        
        // Blurred album art background
        Image {
            anchors.fill: parent
            source: albumArt
            fillMode: Image.PreserveAspectCrop
            opacity: 0.15
            visible: albumArt !== ""
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            
            // Album Art
            Rectangle {
                width: 100
                height: 100
                radius: 12
                color: Kirigami.Theme.highlightColor
                
                Image {
                    anchors.fill: parent
                    source: albumArt
                    fillMode: Image.PreserveAspectCrop
                    visible: albumArt !== ""
                    layer.enabled: true
                }
                
                Kirigami.Icon {
                    anchors.centerIn: parent
                    source: "media-album-cover"
                    width: 48; height: 48
                    color: "white"
                    visible: albumArt === ""
                }
            }
            
            // Info and Controls
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4
                
                PlasmaComponents.Label {
                    text: title
                    font.pixelSize: 14
                    font.weight: Font.SemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                PlasmaComponents.Label {
                    text: artist
                    font.pixelSize: 12
                    opacity: 0.7
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    visible: artist !== ""
                }
                
                PlasmaComponents.Label {
                    text: album
                    font.pixelSize: 11
                    opacity: 0.5
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    visible: album !== ""
                }
                
                Item { Layout.fillHeight: true }
                
                // Controls
                RowLayout {
                    spacing: 4
                    
                    PlasmaComponents.ToolButton {
                        icon.name: "media-skip-backward"
                        onClicked: mpris.action("Previous")
                    }
                    
                    PlasmaComponents.ToolButton {
                        icon.name: isPlaying ? "media-playback-pause" : "media-playback-start"
                        icon.width: 24; icon.height: 24
                        onClicked: mpris.action("PlayPause")
                    }
                    
                    PlasmaComponents.ToolButton {
                        icon.name: "media-skip-forward"
                        onClicked: mpris.action("Next")
                    }
                }
            }
        }
    }
    
    compactRepresentation: Kirigami.Icon {
        source: isPlaying ? "media-playback-pause" : "media-playback-start"
        active: mouseArea.containsMouse
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.expanded = !root.expanded
        }
    }
}
