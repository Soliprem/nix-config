import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var notificationModel
    property bool expanded: false
    property real collapsedHeight: 240
    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeBg
    property color themeRawBg

    readonly property int notificationCount: notificationModel ? notificationModel.values.length : 0

    signal dismissNotification(var notification)
    signal clearRequested()

    radius: 18
    color: Qt.rgba(1, 1, 1, 0.045)
    border {
        width: 1
        color: Qt.rgba(1, 1, 1, 0.08)
    }
    visible: notificationCount > 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                Layout.fillWidth: true
                text: "Notifications"
                color: root.themeFg
                font {
                    family: "JetBrainsMono Nerd Font"
                    pixelSize: 13
                    weight: Font.Bold
                }
            }

            Rectangle {
                Layout.preferredWidth: Math.max(24, countText.implicitWidth + 12)
                Layout.preferredHeight: 22
                radius: 8
                color: Qt.rgba(root.themeAccent.r, root.themeAccent.g, root.themeAccent.b, 0.16)

                Text {
                    id: countText
                    anchors.centerIn: parent
                    text: root.notificationCount
                    color: root.themeAccent
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 10
                        weight: Font.Bold
                    }
                }
            }

            TextButton {
                label: root.expanded ? "Show less" : "Show more"
                themeAccent: root.themeAccent
                themeFg: root.themeFg
                onClicked: root.expanded = !root.expanded
            }

            TextButton {
                label: "Clear"
                themeAccent: root.themeSecond
                themeFg: root.themeFg
                onClicked: root.clearRequested()
            }
        }

        ListView {
            id: notificationList

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            model: root.notificationModel
            cacheBuffer: 0
            reuseItems: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: NotificationCard {
                required property var modelData

                width: ListView.view.width
                notification: modelData
                compact: !root.expanded
                popupMode: false
                themeAccent: root.themeAccent
                themeSecond: root.themeSecond
                themeFg: root.themeFg
                themeBg: root.themeBg
                themeRawBg: root.themeRawBg

                onDismissRequested: (notification) => root.dismissNotification(notification)
            }
        }
    }
}
