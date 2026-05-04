import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Item {
    id: root

    property alias trackedNotifications: server.trackedNotifications
    property alias popupNotifications: popupModel
    property int popupDefaultTimeoutMs: 5000
    property int popupMaxCount: 4
    property bool doNotDisturb: false

    function showPopup(notification) {
        if (!notification || notification.lastGeneration || doNotDisturb)
            return

        const withoutDuplicate = popupModel.values.filter((candidate) => candidate !== notification)
        withoutDuplicate.unshift(notification)
        popupModel.values = withoutDuplicate.slice(0, popupMaxCount)

        notification.closed.connect(() => root.hidePopup(notification))
    }

    function hidePopup(notification) {
        popupModel.values = popupModel.values.filter((candidate) => candidate !== notification)
    }

    function dismissNotification(notification) {
        if (!notification)
            return

        root.hidePopup(notification)
        notification.dismiss()
    }

    function clearNotifications() {
        const notifications = [...server.trackedNotifications.values]
        for (const notification of notifications)
            root.dismissNotification(notification)
    }

    function toggleDoNotDisturb() {
        doNotDisturb = !doNotDisturb

        if (doNotDisturb)
            popupModel.values = []
    }

    NotificationServer {
        id: server

        keepOnReload: true
        persistenceSupported: true

        bodySupported: true
        bodyMarkupSupported: false
        bodyHyperlinksSupported: false
        bodyImagesSupported: false

        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        inlineReplySupported: true

        onNotification: (notification) => {
            notification.tracked = true
            root.showPopup(notification)
        }
    }

    ScriptModel {
        id: popupModel
        values: []
    }
}
