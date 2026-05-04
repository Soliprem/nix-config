import QtQuick

Item {
    id: root

    property string icon
    property color themeAccent
    property color themeFg

    signal clicked()

    width: 44
    height: 44

    Text {
        anchors.centerIn: parent
        text: root.icon
        font.pixelSize: 22
        scale: mouse.pressed ? 0.86 : (mouse.containsMouse ? 1.08 : 1.0)
        color: mouse.containsMouse ? root.themeAccent : root.themeFg
        opacity: mouse.containsMouse ? 1.0 : 0.75

        Behavior on scale { SpringAnimation { spring: 4; damping: 0.4 } }
        Behavior on color { ColorAnimation { duration: 180 } }
        Behavior on opacity { NumberAnimation { duration: 180 } }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
