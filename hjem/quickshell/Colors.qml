import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string fg: "#ffffff"
    property string bg: "#66000000"
    property string rawBg: "#000000"
    property string accent: "#ffffff"
    property string second: "#ffffff"
    property string warm: "#ffffff"
    property string fresh: "#ffffff"

    function colorFilePath() {
        const cacheHome = Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache"
        return cacheHome + "/quickshell/colors.json"
    }

    function reload() {
        colorFile.reload()
    }

    function apply(rawColors) {
        if (!rawColors || rawColors.trim() === "")
            return

        try {
            const c = JSON.parse(rawColors)
            root.rawBg  = c.rawBg
            root.fg     = c.fg
            root.warm   = c.warm
            root.fresh  = c.fresh
            root.accent = c.accent
            root.second = c.second
            root.bg     = "#99" + c.rawBg.slice(1)
        } catch (e) {}
    }

    FileView {
        id: colorFile

        path: root.colorFilePath()
        watchChanges: true
        preload: true
        printErrors: false

        onLoaded: root.apply(text())
        onTextChanged: root.apply(text())
        onFileChanged: reload()
    }
}
