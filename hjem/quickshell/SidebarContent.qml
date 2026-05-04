import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeBg
    property color themeRawBg
    property color themeFresh
    property color themeWarm

    property string batteryPercent
    property string batteryIcon

    property var buttonModel
    property var notificationModel
    property var activePlayer
    property bool hasPlayer: false
    property bool isPlaying: false

    signal requestCmd(var cmdArray)
    signal requestHide()
    signal requestDismissNotification(var notification)
    signal requestClearNotifications()
    signal requestToggleDnd()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 32

        SidebarHeader {
            Layout.fillWidth: true
            themeAccent: root.themeAccent
            themeSecond: root.themeSecond
            batteryIcon: root.batteryIcon
            batteryPercent: root.batteryPercent
        }

        SidebarActions {
            Layout.fillWidth: true
            Layout.preferredHeight: 112

            buttonModel: root.buttonModel
            themeAccent: root.themeAccent
            themeSecond: root.themeSecond
            themeFg: root.themeFg
            themeFresh: root.themeFresh
            themeWarm: root.themeWarm

            onRequestCmd: (cmd) => root.requestCmd(cmd)
            onRequestHide: root.requestHide()
            onRequestToggleDnd: root.requestToggleDnd()
        }

        MediaPlayerCard {
            id: mediaCard

            Layout.fillWidth: true

            activePlayer: root.activePlayer
            hasPlayer: root.hasPlayer
            isPlaying: root.isPlaying
            themeAccent: root.themeAccent
            themeSecond: root.themeSecond
            themeFg: root.themeFg
            themeRawBg: root.themeRawBg
        }

        NotificationCenter {
            id: notificationCenter

            Layout.fillWidth: true
            Layout.fillHeight: expanded
            Layout.preferredHeight: expanded ? 0 : collapsedHeight

            notificationModel: root.notificationModel
            collapsedHeight: mediaCard.visible ? mediaCard.height + 24 : 220
            themeAccent: root.themeAccent
            themeSecond: root.themeSecond
            themeFg: root.themeFg
            themeBg: root.themeBg
            themeRawBg: root.themeRawBg

            onDismissNotification: (notification) => root.requestDismissNotification(notification)
            onClearRequested: root.requestClearNotifications()
        }

        Item { Layout.fillHeight: !notificationCenter.expanded }
    }
}
