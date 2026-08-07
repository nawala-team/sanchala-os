// ============================================
// SANCHALA OS - Intelligent Tiling Script
// ============================================
// Provides smart window tiling with:
// - Master/stack layouts
// - Grid layouts  
// - Golden ratio tiling
// - Keyboard-driven tiling
// ============================================

(function() {
    "use strict";

    // Configuration
    var CONFIG = {
        innerGap: 8,
        outerGap: 12,
        masterRatio: 0.55,
        goldenRatio: 0.618,
        maxMaster: 1,
        minWidth: 400,
        minHeight: 300,
        autoTileEnabled: true,
        ignoredClasses: ["plasmashell", "krunner", "yakuake", "spectacle", "polkit"]
    };

    // Layout Types
    var LAYOUTS = {
        FLOATING: 0, MASTER_STACK: 1, GRID: 2, GOLDEN: 3,
        COLUMNS: 4, ROWS: 5, CENTERED_MASTER: 6
    };

    var desktopLayouts = {};
    var tiledWindows = {};

    function log(msg) { print("[Sanchala Tiling] " + msg); }

    function getKey(desktop, screen) { return desktop + "_" + screen; }

    function shouldIgnore(client) {
        if (!client || !client.normalWindow) return true;
        if (client.specialWindow || client.dialog || client.splash) return true;
        if (client.utility || client.dock || client.fullScreen || client.minimized) return true;
        var cls = client.resourceClass ? client.resourceClass.toString().toLowerCase() : "";
        for (var i = 0; i < CONFIG.ignoredClasses.length; i++) {
            if (cls.indexOf(CONFIG.ignoredClasses[i]) !== -1) return true;
        }
        return false;
    }

    function getGeometry(screen) {
        var area = workspace.clientArea(KWin.PlacementArea, screen, workspace.currentDesktop);
        return {
            x: area.x + CONFIG.outerGap,
            y: area.y + CONFIG.outerGap,
            width: area.width - (CONFIG.outerGap * 2),
            height: area.height - (CONFIG.outerGap * 2)
        };
    }

    function getWindows(desktop, screen) {
        var windows = [];
        var clients = workspace.clientList();
        for (var i = 0; i < clients.length; i++) {
            var c = clients[i];
            if (shouldIgnore(c)) continue;
            if (c.desktop !== desktop && c.desktop !== -1) continue;
            if (c.screen !== screen) continue;
            windows.push(c);
        }
        return windows;
    }

    function setGeom(client, g) {
        if (!client) return;
        client.frameGeometry = {
            x: Math.floor(g.x), y: Math.floor(g.y),
            width: Math.max(Math.floor(g.width), CONFIG.minWidth),
            height: Math.max(Math.floor(g.height), CONFIG.minHeight)
        };
    }

    // Layout: Master/Stack
    function masterStack(wins, geo) {
        if (wins.length === 0) return;
        var gap = CONFIG.innerGap;
        if (wins.length === 1) { setGeom(wins[0], geo); return; }
        var mw = Math.floor(geo.width * CONFIG.masterRatio);
        setGeom(wins[0], {x: geo.x, y: geo.y, width: mw - gap, height: geo.height});
        var sh = Math.floor((geo.height - (gap * (wins.length - 2))) / (wins.length - 1));
        for (var i = 1; i < wins.length; i++) {
            setGeom(wins[i], {
                x: geo.x + mw, y: geo.y + ((i-1) * (sh + gap)),
                width: geo.width - mw, height: sh
            });
        }
    }

    // Layout: Grid
    function grid(wins, geo) {
        if (wins.length === 0) return;
        var gap = CONFIG.innerGap;
        var cols = Math.ceil(Math.sqrt(wins.length));
        var rows = Math.ceil(wins.length / cols);
        var cw = Math.floor((geo.width - (gap * (cols - 1))) / cols);
        var ch = Math.floor((geo.height - (gap * (rows - 1))) / rows);
        for (var i = 0; i < wins.length; i++) {
            var col = i % cols, row = Math.floor(i / cols);
            setGeom(wins[i], {
                x: geo.x + (col * (cw + gap)), y: geo.y + (row * (ch + gap)),
                width: cw, height: ch
            });
        }
    }

    // Layout: Golden Ratio
    function golden(wins, geo) {
        if (wins.length === 0) return;
        if (wins.length === 1) { setGeom(wins[0], geo); return; }
        var gap = CONFIG.innerGap, r = CONFIG.goldenRatio;
        var mw = Math.floor(geo.width * r);
        setGeom(wins[0], {x: geo.x, y: geo.y, width: mw - gap, height: geo.height});
        var rem = {x: geo.x + mw, y: geo.y, width: geo.width - mw, height: geo.height};
        var horiz = false;
        for (var i = 1; i < wins.length; i++) {
            if (i === wins.length - 1) { setGeom(wins[i], rem); }
            else if (horiz) {
                var w = Math.floor(rem.width * r);
                setGeom(wins[i], {x: rem.x, y: rem.y, width: w - gap, height: rem.height});
                rem.x += w; rem.width -= w;
            } else {
                var h = Math.floor(rem.height * r);
                setGeom(wins[i], {x: rem.x, y: rem.y, width: rem.width, height: h - gap});
                rem.y += h; rem.height -= h;
            }
            horiz = !horiz;
        }
    }

    // Layout: Columns
    function columns(wins, geo) {
        if (wins.length === 0) return;
        var gap = CONFIG.innerGap;
        var cw = Math.floor((geo.width - (gap * (wins.length - 1))) / wins.length);
        for (var i = 0; i < wins.length; i++) {
            setGeom(wins[i], {x: geo.x + (i * (cw + gap)), y: geo.y, width: cw, height: geo.height});
        }
    }

    // Layout: Rows
    function rows(wins, geo) {
        if (wins.length === 0) return;
        var gap = CONFIG.innerGap;
        var rh = Math.floor((geo.height - (gap * (wins.length - 1))) / wins.length);
        for (var i = 0; i < wins.length; i++) {
            setGeom(wins[i], {x: geo.x, y: geo.y + (i * (rh + gap)), width: geo.width, height: rh});
        }
    }

    // Layout: Centered Master
    function centeredMaster(wins, geo) {
        if (wins.length === 0) return;
        if (wins.length === 1) {
            var w = Math.floor(geo.width * 0.8), h = Math.floor(geo.height * 0.8);
            setGeom(wins[0], {x: geo.x + (geo.width-w)/2, y: geo.y + (geo.height-h)/2, width: w, height: h});
            return;
        }
        var gap = CONFIG.innerGap;
        var mw = Math.floor(geo.width * 0.5);
        var sw = Math.floor((geo.width - mw - gap * 2) / 2);
        setGeom(wins[0], {x: geo.x + sw + gap, y: geo.y, width: mw, height: geo.height});
        var left = Math.ceil((wins.length - 1) / 2), right = wins.length - 1 - left;
        if (left > 0) {
            var lh = Math.floor((geo.height - gap * (left - 1)) / left);
            for (var i = 0; i < left; i++) {
                setGeom(wins[1 + i], {x: geo.x, y: geo.y + i * (lh + gap), width: sw, height: lh});
            }
        }
        if (right > 0) {
            var rh = Math.floor((geo.height - gap * (right - 1)) / right);
            for (var j = 0; j < right; j++) {
                setGeom(wins[1 + left + j], {x: geo.x + sw + mw + gap * 2, y: geo.y + j * (rh + gap), width: sw, height: rh});
            }
        }
    }

    // Tiling Engine
    function tileDesktop(desktop, screen) {
        var key = getKey(desktop, screen);
        var layout = desktopLayouts[key] || LAYOUTS.MASTER_STACK;
        var wins = getWindows(desktop, screen);
        var geo = getGeometry(screen);
        if (layout === LAYOUTS.FLOATING || wins.length === 0) return;
        
        switch (layout) {
            case LAYOUTS.MASTER_STACK: masterStack(wins, geo); break;
            case LAYOUTS.GRID: grid(wins, geo); break;
            case LAYOUTS.GOLDEN: golden(wins, geo); break;
            case LAYOUTS.COLUMNS: columns(wins, geo); break;
            case LAYOUTS.ROWS: rows(wins, geo); break;
            case LAYOUTS.CENTERED_MASTER: centeredMaster(wins, geo); break;
        }
    }

    function retile() {
        var d = workspace.currentDesktop;
        for (var s = 0; s < workspace.numScreens; s++) tileDesktop(d, s);
    }

    function cycleLayout() {
        var d = workspace.currentDesktop, s = workspace.activeScreen;
        var key = getKey(d, s);
        var cur = desktopLayouts[key] || LAYOUTS.MASTER_STACK;
        desktopLayouts[key] = (cur + 1) % 7;
        var names = ["Floating", "Master/Stack", "Grid", "Golden", "Columns", "Rows", "Centered"];
        log("Layout: " + names[desktopLayouts[key]]);
        tileDesktop(d, s);
    }

    function setLayout(l) {
        var key = getKey(workspace.currentDesktop, workspace.activeScreen);
        desktopLayouts[key] = l;
        retile();
    }

    // Event handlers
    function onClientAdded(c) { if (!shouldIgnore(c)) { tiledWindows[c.windowId] = true; retile(); } }
    function onClientRemoved(c) { if (tiledWindows[c.windowId]) { delete tiledWindows[c.windowId]; retile(); } }
    function onMinimize() { retile(); }

    // Shortcuts
    function registerShortcuts() {
        registerShortcut("Sanchala: Cycle Layout", "Cycle tiling layouts", "Meta+T", cycleLayout);
        registerShortcut("Sanchala: Retile", "Retile desktop", "Meta+Shift+T", retile);
        registerShortcut("Sanchala: Floating", "Floating layout", "Meta+Shift+F", function() { setLayout(LAYOUTS.FLOATING); });
        registerShortcut("Sanchala: Master/Stack", "Master/Stack layout", "Meta+Shift+M", function() { setLayout(LAYOUTS.MASTER_STACK); });
        registerShortcut("Sanchala: Grid", "Grid layout", "Meta+Shift+G", function() { setLayout(LAYOUTS.GRID); });
        registerShortcut("Sanchala: Golden", "Golden ratio layout", "Meta+Shift+R", function() { setLayout(LAYOUTS.GOLDEN); });
        registerShortcut("Sanchala: Promote", "Promote to master", "Meta+Return", function() {
            var c = workspace.activeClient;
            if (!c || shouldIgnore(c)) return;
            var wins = getWindows(workspace.currentDesktop, c.screen);
            var idx = wins.indexOf(c);
            if (idx > 0) { var t = wins[0]; wins[0] = c; wins[idx] = t; retile(); }
        });
    }

    // Initialize
    function init() {
        log("Initializing Sanchala Tiling v1.0.0");
        for (var d = 1; d <= workspace.desktops; d++) {
            for (var s = 0; s < workspace.numScreens; s++) {
                desktopLayouts[getKey(d, s)] = LAYOUTS.MASTER_STACK;
            }
        }
        workspace.clientAdded.connect(onClientAdded);
        workspace.clientRemoved.connect(onClientRemoved);
        workspace.clientMinimized.connect(onMinimize);
        workspace.clientUnminimized.connect(onMinimize);
        workspace.currentDesktopChanged.connect(retile);
        registerShortcuts();
        log("Sanchala Tiling initialized");
    }

    init();
})();
