import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property var notificationModel
    property int popupDefaultTimeoutMs: 5000
    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeRawBg

    signal dismissNotification(var notification)
    signal hidePopup(var notification)

    function timeoutFor(notification) {
        if (notification && notification.expireTimeout > 0)
            return Math.max(2500, Math.min(10000, notification.expireTimeout * 1000))

        return popupDefaultTimeoutMs
    }

    WlrLayershell.namespace: "quantum-notification-popups"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        right: true
    }

    margins {
        top: 10
        right: 10
    }

    implicitWidth: 360
    implicitHeight: popupColumn.implicitHeight
    color: "transparent"
    visible: notificationModel && notificationModel.values.length > 0

    ColumnLayout {
        id: popupColumn

        anchors.fill: parent
        spacing: 10

        Repeater {
            model: root.notificationModel

            delegate: NotificationCard {
                id: popupCard

                required property var modelData

                Layout.fillWidth: true
                notification: modelData
                compact: true
                popupMode: true
                themeAccent: root.themeAccent
                themeSecond: root.themeSecond
                themeFg: root.themeFg
                themeRawBg: root.themeRawBg

                onDismissRequested: (notification) => root.dismissNotification(notification)

                Timer {
                    interval: root.timeoutFor(popupCard.notification)
                    running: true
                    repeat: false
                    onTriggered: root.hidePopup(popupCard.notification)
                }
            }
        }
    }
}
