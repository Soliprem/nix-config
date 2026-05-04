import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property color themeAccent
    property color themeSecond
    property string batteryPercent
    property string batteryIcon

    Layout.alignment: Qt.AlignLeft
    spacing: 4

    Text {
        id: clockText

        Layout.alignment: Qt.AlignLeft
        Layout.leftMargin: -6
        horizontalAlignment: Text.AlignLeft
        color: root.themeAccent
        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 72
            weight: Font.ExtraLight
        }

        Component.onCompleted: text = Qt.formatTime(new Date(), "hh:mm")

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: clockText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignLeft
        spacing: 14

        Text {
            text: Qt.formatDate(new Date(), "dddd, d MMMM").toUpperCase()
            color: root.themeSecond
            font {
                family: "JetBrainsMono Nerd Font"
                pixelSize: 11
                weight: Font.Medium
                letterSpacing: 0.2
            }
        }

        Text {
            text: root.batteryIcon + " " + root.batteryPercent
            color: root.themeAccent
            font {
                family: "JetBrainsMono Nerd Font"
                pixelSize: 11
                weight: Font.Bold
            }
        }
    }
}
