import QtQuick

Rectangle {
    id: root

    property string label
    property color themeAccent
    property color themeFg

    signal clicked()

    implicitWidth: text.implicitWidth + 14
    implicitHeight: 24
    radius: 8
    color: mouse.containsMouse
        ? Qt.rgba(themeAccent.r, themeAccent.g, themeAccent.b, 0.18)
        : Qt.rgba(1, 1, 1, 0.06)

    Behavior on color { ColorAnimation { duration: 140 } }

    Text {
        id: text
        anchors.centerIn: parent
        text: root.label
        color: root.themeAccent
        font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 10
            weight: Font.Bold
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
