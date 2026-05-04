import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Rectangle {
    id: root

    property var notification
    property bool compact: false
    property bool popupMode: false
    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeRawBg

    signal dismissRequested(var notification)
    signal hidePopupRequested(var notification)

    readonly property string appName: notification?.appName || "Application"
    readonly property string summary: notification?.summary || "Notification"
    readonly property string body: notification?.body || ""
    readonly property int urgency: notification ? notification.urgency : NotificationUrgency.Normal
    readonly property bool critical: urgency === NotificationUrgency.Critical
    readonly property bool low: urgency === NotificationUrgency.Low
    readonly property string imageSource: imageUrl()

    function imageUrl() {
        if (!notification)
            return ""

        if (notification.image !== "")
            return notification.image.startsWith("/") ? "file://" + notification.image : notification.image

        if (notification.appIcon !== "") {
            const path = Quickshell.iconPath(notification.appIcon, true)
            return path !== "" ? "file://" + path : ""
        }

        return ""
    }

    function invokeAction(action) {
        if (!action || !notification)
            return

        action.invoke()
        if (!notification.resident)
            root.dismissRequested(notification)
    }

    function preferredAction() {
        if (!notification || notification.actions.length === 0)
            return null

        for (let i = 0; i < notification.actions.length; i++) {
            const action = notification.actions[i]
            if (action.identifier === "default")
                return action
        }

        return notification.actions[0]
    }

    function activateNotification() {
        const action = preferredAction()
        if (action)
            invokeAction(action)
    }

    function sendReply() {
        if (!notification || replyInput.text.trim() === "")
            return

        notification.sendInlineReply(replyInput.text)
        replyInput.text = ""

        if (!notification.resident)
            root.dismissRequested(notification)
    }

    width: parent ? parent.width : implicitWidth
    implicitHeight: content.implicitHeight + 24
    radius: 14
    color: critical
        ? Qt.rgba(themeAccent.r, themeAccent.g, themeAccent.b, popupMode ? 0.22 : 0.15)
        : Qt.rgba(1, 1, 1, popupMode ? 0.22 : 0.06)
    border {
        width: critical ? 2 : 1
        color: critical
            ? root.themeAccent
            : low
                ? Qt.rgba(root.themeSecond.r, root.themeSecond.g, root.themeSecond.b, 0.35)
                : Qt.rgba(root.themeFg.r, root.themeFg.g, root.themeFg.b, 0.14)
    }

    RetainableLock {
        object: root.notification
        locked: root.visible
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton)
                root.dismissRequested(root.notification)
            else if (mouse.button === Qt.LeftButton)
                root.activateNotification()
        }
    }

    ColumnLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 12
        spacing: 9

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 34
                Layout.preferredHeight: 34
                radius: 9
                color: Qt.rgba(root.themeFg.r, root.themeFg.g, root.themeFg.b, 0.08)
                clip: true

                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: root.imageSource
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    visible: status === Image.Ready
                }

                Text {
                    anchors.centerIn: parent
                    text: root.critical ? "!" : "󰂚"
                    color: root.critical ? root.themeAccent : root.themeSecond
                    visible: root.imageSource === ""
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 15
                        bold: root.critical
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    Layout.fillWidth: true
                    text: root.appName
                    color: root.themeSecond
                    opacity: 0.78
                    elide: Text.ElideRight
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 10
                        weight: Font.Medium
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: root.summary
                    color: root.themeFg
                    elide: Text.ElideRight
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 13
                        weight: Font.Bold
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.body !== ""
            text: root.body
            textFormat: Text.PlainText
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: root.compact ? 2 : 5
            elide: Text.ElideRight
            color: root.themeFg
            opacity: 0.74
            font {
                family: "JetBrainsMono Nerd Font"
                pixelSize: 11
            }
        }

        Image {
            Layout.fillWidth: true
            Layout.preferredHeight: root.compact ? 82 : 130
            visible: root.imageSource !== "" && !root.compact
            source: root.imageSource
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
        }

        RowLayout {
            Layout.fillWidth: true
            visible: root.notification && root.notification.hasInlineReply
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.06)
                border {
                    width: replyInput.activeFocus ? 1 : 0
                    color: root.themeAccent
                }

                TextInput {
                    id: replyInput

                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    clip: true
                    color: root.themeFg
                    selectedTextColor: root.themeRawBg
                    selectionColor: root.themeAccent
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 11
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.notification?.inlineReplyPlaceholder || "Reply"
                        color: root.themeSecond
                        opacity: 0.55
                        visible: replyInput.text === ""
                        font: replyInput.font
                    }

                    Keys.onReturnPressed: root.sendReply()
                    Keys.onEnterPressed: root.sendReply()
                }
            }

            Rectangle {
                Layout.preferredWidth: 52
                Layout.preferredHeight: 30
                radius: 8
                color: sendMouse.containsMouse
                    ? Qt.rgba(root.themeAccent.r, root.themeAccent.g, root.themeAccent.b, 0.25)
                    : Qt.rgba(root.themeAccent.r, root.themeAccent.g, root.themeAccent.b, 0.14)

                Text {
                    anchors.centerIn: parent
                    text: "Send"
                    color: root.themeAccent
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 10
                        weight: Font.Bold
                    }
                }

                MouseArea {
                    id: sendMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.sendReply()
                }
            }
        }
    }
}
