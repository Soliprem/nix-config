import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Mpris
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    Colors { id: colors }

    property alias themeFg: colors.fg
    property alias themeBg: colors.bg
    property alias themeRawBg: colors.rawBg
    property alias themeAccent: colors.accent
    property alias themeSecond: colors.second
    property alias themeWarm: colors.warm
    property alias themeFresh: colors.fresh

    property string batteryPercent: "100%"
    property string batteryIcon:    "󰁹"

    function reloadColors()     { colors.reload() }
    function runCmd(cmd)        { cmdProc.command = cmd; cmdProc.running = true }

    function toggleDoNotDisturb() {
        notificationDaemon.toggleDoNotDisturb()

        for (let i = 0; i < buttonModel.count; i++) {
            if (buttonModel.get(i).action === "dnd") {
                buttonModel.setProperty(i, "icon", notificationDaemon.doNotDisturb ? "󰂛" : "󰂚")
                buttonModel.setProperty(i, "color_role", notificationDaemon.doNotDisturb ? "warm" : "second")
                break
            }
        }
    }

    Component.onCompleted: {
        reloadColors()
        batProc.running  = true
    }

    NotificationDaemon {
        id: notificationDaemon
    }

    // ── battery ──

    Process {
        id: batProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n 1; cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n 1"]
        property string buffer: ""
        stdout: SplitParser { onRead: (data) => batProc.buffer += data + "\n" }
        onExited: {
            const lines = batProc.buffer.trim().split("\n")
            if (lines.length >= 2) {
                const cap  = parseInt(lines[0])
                const stat = lines[1]
                batteryPercent = cap + "%"
                batteryIcon =
                    stat === "Charging" ? "󰂄" :
                    cap > 90 ? "󰁹" :
                    cap > 70 ? "󰂀" :
                    cap > 40 ? "󰁾" :
                    cap > 10 ? "󰁼" : "󰂎"
            }
            batProc.buffer = ""
        }
    }

    Timer {
        interval: 60000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: batProc.running = true
    }

    // ── utility proc ──

    Process { id: cmdProc }

    // ── IPC ──

    IpcHandler {
        target: "sidebar"
        function toggle() { sidebarWindow.visible = !sidebarWindow.visible }
    }

    IpcHandler {
        target: "theme_manager"
        function update() { reloadColors() }
    }

    IpcHandler {
        target: "notifications"
        function toggleDnd() { root.toggleDoNotDisturb() }
        function clear() { notificationDaemon.clearNotifications() }
    }

    // ── sidebar buttons ──

    ListModel {
        id: buttonModel
        ListElement { icon: "󰍜"; color_role: "second"; action: "cmd";           binary: "fuzzel"; args: "" }
        ListElement { icon: "󱙓"; color_role: "second"; action: "cmd";           binary: "nixrice"; args: "" }
        ListElement { icon: "󰂯"; color_role: "second"; action: "cmd";           binary: "ghostty"; args: "-e bluetui" }
        ListElement { icon: "󰖩"; color_role: "accent"; action: "cmd";           binary: "ghostty";           args: "-e nmtui" }
        ListElement { icon: "󰏘"; color_role: "accent"; action: "cmd";           binary: "color-mode";         args: "" }
        ListElement { icon: "󰂚"; color_role: "second"; action: "dnd";           binary: "";                   args: "" }
        ListElement { icon: "󰤆"; color_role: "second"; action: "cmd";           binary: "wlogout";            args: "" }
        ListElement { icon: "󰄨"; color_role: "second"; action: "cmd";           binary: "ghostty";           args: "-e btop" }
        ListElement { icon: "󰕾"; color_role: "accent"; action: "cmd";           binary: "ghostty";     args: "-e wiremix" }

    }

    // ── sidebar window ──

    PanelWindow {
        id: sidebarWindow
        WlrLayershell.namespace: "quickshell-sidebar"
        WlrLayershell.layer:         WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        // exclusiveZone: 0
        anchors { top: true; bottom: true; right: true }
        margins { top: 10; bottom: 10; right: 10 }
        implicitWidth: 360
        visible: false
        color: "transparent"

        readonly property MprisPlayer activePlayer:
            Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
        readonly property bool hasPlayer: activePlayer !== null
        readonly property bool isPlaying: hasPlayer && activePlayer.playbackState === MprisPlaybackState.Playing

        Rectangle {
            anchors.fill: parent
            radius: 15
            color:  root.themeBg
            clip:   true

            SidebarContent {
                anchors.fill: parent
                visible: sidebarWindow.visible

                themeAccent: root.themeAccent
                themeSecond: root.themeSecond
                themeFg:     root.themeFg
                themeRawBg:  root.themeRawBg
                themeFresh:  root.themeFresh
                themeWarm:   root.themeWarm

                batteryPercent: root.batteryPercent
                batteryIcon:    root.batteryIcon

                buttonModel:  buttonModel
                notificationModel: notificationDaemon.trackedNotifications
                activePlayer: sidebarWindow.activePlayer
                hasPlayer:    sidebarWindow.hasPlayer
                isPlaying:    sidebarWindow.isPlaying

                onRequestCmd: (cmd) => root.runCmd(cmd)
                onRequestHide:       sidebarWindow.visible = false
                onRequestDismissNotification: (notification) => notificationDaemon.dismissNotification(notification)
                onRequestClearNotifications: notificationDaemon.clearNotifications()
                onRequestToggleDnd: root.toggleDoNotDisturb()
            }
        }
    }

    NotificationPopupStack {
        notificationModel: notificationDaemon.popupNotifications
        popupDefaultTimeoutMs: notificationDaemon.popupDefaultTimeoutMs
        themeAccent: root.themeAccent
        themeSecond: root.themeSecond
        themeFg:     root.themeFg
        themeRawBg:  root.themeRawBg

        onDismissNotification: (notification) => notificationDaemon.dismissNotification(notification)
        onHidePopup: (notification) => notificationDaemon.hidePopup(notification)
    }

}
