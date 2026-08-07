// ============================================
// SANCHALA OS - Quick Tile Script
// ============================================
// Enhanced window snapping with:
// - Quarter tiling (corners)
// - Third tiling (horizontal/vertical)
// - Center snap
// - Keyboard shortcuts
// ============================================

(function() {
    "use strict";

    var CONFIG = {
        gap: 8,
        animDuration: 150
    };

    function log(msg) { print("[Sanchala Quick Tile] " + msg); }

    function getArea() {
        var a = workspace.clientArea(KWin.PlacementArea, workspace.activeScreen, workspace.currentDesktop);
        return {
            x: a.x + CONFIG.gap, y: a.y + CONFIG.gap,
            width: a.width - CONFIG.gap * 2, height: a.height - CONFIG.gap * 2
        };
    }

    function tile(client, x, y, w, h) {
        if (!client) return;
        var area = getArea();
        client.frameGeometry = {
            x: area.x + Math.floor(area.width * x),
            y: area.y + Math.floor(area.height * y),
            width: Math.floor(area.width * w) - CONFIG.gap,
            height: Math.floor(area.height * h) - CONFIG.gap
        };
    }

    // Tile positions
    function tileLeft(c)        { tile(c, 0, 0, 0.5, 1); }
    function tileRight(c)       { tile(c, 0.5, 0, 0.5, 1); }
    function tileTop(c)         { tile(c, 0, 0, 1, 0.5); }
    function tileBottom(c)      { tile(c, 0, 0.5, 1, 0.5); }
    function tileTopLeft(c)     { tile(c, 0, 0, 0.5, 0.5); }
    function tileTopRight(c)    { tile(c, 0.5, 0, 0.5, 0.5); }
    function tileBottomLeft(c)  { tile(c, 0, 0.5, 0.5, 0.5); }
    function tileBottomRight(c) { tile(c, 0.5, 0.5, 0.5, 0.5); }
    function tileCenter(c)      { tile(c, 0.15, 0.1, 0.7, 0.8); }
    function tileLeft3rd(c)     { tile(c, 0, 0, 0.333, 1); }
    function tileCenter3rd(c)   { tile(c, 0.333, 0, 0.334, 1); }
    function tileRight3rd(c)    { tile(c, 0.667, 0, 0.333, 1); }
    function tileLeft2_3(c)     { tile(c, 0, 0, 0.667, 1); }
    function tileRight2_3(c)    { tile(c, 0.333, 0, 0.667, 1); }
    function maximize(c)        { if (c) c.setMaximize(true, true); }

    function init() {
        log("Initializing Quick Tile v1.0.0");
        
        // Half tiles
        registerShortcut("Sanchala: Tile Left", "Tile left half", "Meta+Left", 
            function() { tileLeft(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Right", "Tile right half", "Meta+Right", 
            function() { tileRight(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Top", "Tile top half", "Meta+Up", 
            function() { tileTop(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Bottom", "Tile bottom half", "Meta+Down", 
            function() { tileBottom(workspace.activeClient); });
        
        // Quarter tiles
        registerShortcut("Sanchala: Tile Top-Left", "Tile top-left quarter", "Meta+U", 
            function() { tileTopLeft(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Top-Right", "Tile top-right quarter", "Meta+I", 
            function() { tileTopRight(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Bottom-Left", "Tile bottom-left quarter", "Meta+J", 
            function() { tileBottomLeft(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Bottom-Right", "Tile bottom-right quarter", "Meta+K", 
            function() { tileBottomRight(workspace.activeClient); });
        
        // Thirds
        registerShortcut("Sanchala: Tile Left Third", "Tile left third", "Meta+1", 
            function() { tileLeft3rd(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Center Third", "Tile center third", "Meta+2", 
            function() { tileCenter3rd(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Right Third", "Tile right third", "Meta+3", 
            function() { tileRight3rd(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Left 2/3", "Tile left two-thirds", "Meta+4", 
            function() { tileLeft2_3(workspace.activeClient); });
        registerShortcut("Sanchala: Tile Right 2/3", "Tile right two-thirds", "Meta+5", 
            function() { tileRight2_3(workspace.activeClient); });
        
        // Center and maximize
        registerShortcut("Sanchala: Tile Center", "Tile center", "Meta+C", 
            function() { tileCenter(workspace.activeClient); });
        registerShortcut("Sanchala: Maximize", "Maximize window", "Meta+M", 
            function() { maximize(workspace.activeClient); });
        
        log("Quick Tile initialized");
    }

    init();
})();
