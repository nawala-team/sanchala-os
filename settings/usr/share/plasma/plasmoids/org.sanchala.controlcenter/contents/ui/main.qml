/*
 * Sanchala Control Center - Main Entry Point
 * macOS-style unified quick settings plasmoid
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright (C) 2026 Sanchala Team
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami

PlasmoidItem {
    id: root
    
    // Compact representation (system tray icon)
    compactRepresentation: CompactIcon {}
    
    // Full representation (expanded panel)
    fullRepresentation: ControlCenter {}
    
    // Prefer popup over expanding in place
    preferredRepresentation: compactRepresentation
    
    // Panel dimensions
    Plasmoid.backgroundHints: PlasmaCore.Types.TranslucentBackground
    
    toolTipMainText: i18n("Control Center")
    toolTipSubText: i18n("Quick access to system settings")
    
    // Switch representation based on form factor
    switchWidth: Kirigami.Units.gridUnit * 20
    switchHeight: Kirigami.Units.gridUnit * 26
}
