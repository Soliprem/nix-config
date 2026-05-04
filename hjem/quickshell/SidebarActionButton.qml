import QtQuick

Item {
    id: root

    property string icon
    property string action
    property string binary
    property string args
    property color roleColor
    property color themeFg

    signal clicked()

    width: 50
    height: 50

    Rectangle {
        anchors.centerIn: parent
        width: 50
        height: 50
        radius: 14
        color: "transparent"
        opacity: mouse.containsMouse ? 1.0 : 0.0
        scale: mouse.containsMouse ? 1.35 : 1.0

        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.centerIn: parent
            width: 44
            height: 44
            radius: 12
            color: Qt.rgba(root.roleColor.r, root.roleColor.g, root.roleColor.b, 0.12)

            Behavior on color { ColorAnimation { duration: 180 } }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: mouse.pressed
            ? Qt.rgba(1, 1, 1, 0.10)
            : mouse.containsMouse
                ? Qt.rgba(1, 1, 1, 0.07)
                : Qt.rgba(1, 1, 1, 0.04)
        scale: mouse.pressed ? 0.91 : 1.0

        Behavior on color { ColorAnimation { duration: 180 } }
        Behavior on scale { SpringAnimation { spring: 7; damping: 0.42 } }

        border {
            width: 1
            color: mouse.containsMouse
                ? Qt.rgba(root.roleColor.r, root.roleColor.g, root.roleColor.b, 0.55)
                : Qt.rgba(1, 1, 1, 0.09)
        }

        Behavior on border.color { ColorAnimation { duration: 220 } }

        Text {
            anchors.centerIn: parent
            text: root.icon
            color: mouse.containsMouse
                ? root.roleColor
                : Qt.rgba(root.themeFg.r, root.themeFg.g, root.themeFg.b, 0.55)
            scale: mouse.pressed ? 0.88 : (mouse.containsMouse ? 1.10 : 1.0)
            font {
                family: "JetBrainsMono Nerd Font"
                pixelSize: 21
            }

            Behavior on color { ColorAnimation { duration: 200 } }
            Behavior on scale { SpringAnimation { spring: 7; damping: 0.38 } }
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.clicked()
        }
    }
}
