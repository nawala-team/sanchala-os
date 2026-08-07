// ============================================
// SANCHALA OS - Stage Manager Script
// ============================================
// macOS-style Stage Manager with window grouping
// ============================================

(function() {
    "use strict";

    var CONFIG = {
        enabled: false,
        stripWidth: 160,
        stripGap: 12,
        mainAreaMargin: 20,
        maxStrips: 6,
        groupByApp: true
    };

    var windowGroups = {};
    var activeGroup = null;

    function log(msg) { print("[Sanchala Stage Manager] " + msg); }

    function getAppId(c) {
        return c.resourceClass ? c.resourceClass.toString() : "unknown";
    }

    function shouldIgnore(c) {
        if (!c || !c.normalWindow) return true;
        if (c.specialWindow || c.dialog || c.splash || c.utility || c.dock) return true;
        var cls = c.resourceClass ? c.resourceClass.toString().toLowerCase() : "";
        var ignored = ["plasmashell", "krunner", "yakuake", "spectacle"];
        for (var i = 0; i < ignored.length; i++) {
            if (cls.indexOf(ignored[i]) !== -1) return true;
        }
        return false;
    }

    function getScreenGeo() {
        return workspace.clientArea(KWin.PlacementArea, workspace.activeScreen, workspace.currentDesktop);
    }

    function updateGroups() {
        windowGroups = {};
        var clients = workspace.clientList();
        for (var i = 0; i < clients.length; i++) {
            var c = clients[i];
            if (shouldIgnore(c)) continue;
            if (c.desktop !== workspace.currentDesktop && c.desktop !== -1) continue;
            var appId = CONFIG.groupByApp ? getAppId(c) : c.windowId.toString();
            if (!windowGroups[appId]) windowGroups[appId] = [];
            windowGroups[appId].push(c);
        }
    }

    function getMainArea() {
        var geo = getScreenGeo();
        return {
            x: geo.x + CONFIG.stripWidth + CONFIG.mainAreaMargin,
            y: geo.y + CONFIG.mainAreaMargin,
            width: geo.width - CONFIG.stripWidth - CONFIG.mainAreaMargin * 2,
            height: geo.height - CONFIG.mainAreaMargin * 2
        };
    }

    function arrangeActiveGroup() {
        if (!activeGroup || !windowGroups[activeGroup]) return;
        var wins = windowGroups[activeGroup];
        var main = getMainArea();
        var gap = CONFIG.stripGap;
        
        if (wins.length === 1) {
            wins[0].frameGeometry = main;
        } else {
            var cols = Math.ceil(Math.sqrt(wins.length));
            var rows = Math.ceil(wins.length / cols);
            var cw = Math.floor((main.width - gap * (cols - 1)) / cols);
            var ch = Math.floor((main.height - gap * (rows - 1)) / rows);
            for (var i = 0; i < wins.length; i++) {
                var col = i % cols, row = Math.floor(i / cols);
                wins[i].frameGeometry = {
                    x: main.x + col * (cw + gap), y: main.y + row * (ch + gap),
                    width: cw, height: ch
                };
                wins[i].minimized = false;
            }
        }
    }

    function arrangeStrips() {
        var geo = getScreenGeo();
        var stripX = geo.x + CONFIG.stripGap;
        var stripY = geo.y + CONFIG.stripGap;
        var stripH = Math.floor((geo.height - CONFIG.stripGap * (CONFIG.maxStrips + 1)) / CONFIG.maxStrips);
        var groupIds = Object.keys(windowGroups);
        var count = 0;
        
        for (var i = 0; i < groupIds.length && count < CONFIG.maxStrips; i++) {
            var gid = groupIds[i];
            if (gid === activeGroup) continue;
            var wins = windowGroups[gid];
            if (wins.length > 0) {
                wins[0].frameGeometry = {
                    x: stripX, y: stripY + count * (stripH + CONFIG.stripGap),
                    width: CONFIG.stripWidth - CONFIG.stripGap * 2, height: stripH
                };
                for (var j = 1; j < wins.length; j++) wins[j].minimized = true;
                count++;
            }
        }
    }

    function activateGroup(appId) {
        activeGroup = appId;
        arrangeActiveGroup();
        arrangeStrips();
    }

    function toggle() {
        CONFIG.enabled = !CONFIG.enabled;
        log("Stage Manager " + (CONFIG.enabled ? "enabled" : "disabled"));
        if (CONFIG.enabled) {
            updateGroups();
            var groups = Object.keys(windowGroups);
            if (groups.length > 0) activeGroup = groups[0];
            arrangeActiveGroup();
            arrangeStrips();
        }
    }

    function cycleGroups() {
        if (!CONFIG.enabled) return;
        var groups = Object.keys(windowGroups);
        if (groups.length < 2) return;
        var idx = groups.indexOf(activeGroup);
        activateGroup(groups[(idx + 1) % groups.length]);
    }

    function init() {
        log("Initializing Stage Manager v1.0.0");
        registerShortcut("Sanchala: Toggle Stage Manager", "Toggle Stage Manager", "Meta+S", toggle);
        registerShortcut("Sanchala: Cycle Stage Groups", "Cycle groups", "Meta+`", cycleGroups);
        workspace.clientActivated.connect(function(c) {
            if (!CONFIG.enabled || !c || shouldIgnore(c)) return;
            var appId = CONFIG.groupByApp ? getAppId(c) : c.windowId.toString();
            if (appId !== activeGroup) activateGroup(appId);
        });
        workspace.clientAdded.connect(function() { if (CONFIG.enabled) updateGroups(); });
        workspace.clientRemoved.connect(function() { if (CONFIG.enabled) updateGroups(); });
        log("Stage Manager initialized");
    }

    init();
})();
