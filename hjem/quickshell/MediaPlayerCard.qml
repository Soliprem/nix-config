import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

Rectangle {
    id: root

    property var activePlayer
    property bool hasPlayer: false
    property bool isPlaying: false
    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeRawBg

    Layout.preferredHeight: playerLayout.implicitHeight + 40
    radius: 24
    color: "#12ffffff"
    border {
        width: 1
        color: "#0effffff"
    }
    visible: root.hasPlayer

    ColumnLayout {
        id: playerLayout

        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 18

            Rectangle {
                id: artContainer

                width: 85
                height: 85
                radius: 20
                color: "#2affffff"
                clip: true
                layer.enabled: true
                layer.samples: 8
                layer.smooth: true

                readonly property int renderScale: 4
                readonly property int renderSize: Math.round(width * renderScale)
                property bool showingA: true
                property string artUrl: root.activePlayer?.trackArtUrl ?? ""

                onArtUrlChanged: {
                    if (showingA) {
                        imgB.source = artUrl
                        if (imgB.status === Image.Ready)
                            showingA = false
                    } else {
                        imgA.source = artUrl
                        if (imgA.status === Image.Ready)
                            showingA = true
                    }
                }

                Component.onCompleted: imgA.source = artUrl

                Item {
                    id: artMask

                    width: artContainer.renderSize
                    height: artContainer.renderSize
                    layer.enabled: true
                    layer.samples: 8
                    layer.smooth: true
                    layer.mipmap: true
                    visible: false

                    Rectangle {
                        anchors.fill: parent
                        radius: artContainer.radius * artContainer.renderScale
                        color: "white"
                        antialiasing: true
                    }
                }

                Image {
                    id: imgA

                    width: artContainer.renderSize
                    height: artContainer.renderSize
                    sourceSize.width: artContainer.renderSize
                    sourceSize.height: artContainer.renderSize
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    antialiasing: true
                    visible: false

                    onStatusChanged: {
                        if (status === Image.Ready && !artContainer.showingA)
                            artContainer.showingA = true
                    }
                }

                MultiEffect {
                    anchors.fill: parent
                    source: imgA
                    maskEnabled: true
                    maskSource: artMask
                    maskThresholdMin: 0.35
                    maskThresholdMax: 1.0
                    maskSpreadAtMin: 0.08
                    maskSpreadAtMax: 0.04
                    opacity: artContainer.showingA ? 1.0 : 0.0
                    visible: imgA.status === Image.Ready
                    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                }

                Image {
                    id: imgB

                    width: artContainer.renderSize
                    height: artContainer.renderSize
                    sourceSize.width: artContainer.renderSize
                    sourceSize.height: artContainer.renderSize
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    antialiasing: true
                    visible: false

                    onStatusChanged: {
                        if (status === Image.Ready && artContainer.showingA)
                            artContainer.showingA = false
                    }
                }

                MultiEffect {
                    anchors.fill: parent
                    source: imgB
                    maskEnabled: true
                    maskSource: artMask
                    maskThresholdMin: 0.35
                    maskThresholdMax: 1.0
                    maskSpreadAtMin: 0.08
                    maskSpreadAtMax: 0.04
                    opacity: artContainer.showingA ? 0.0 : 1.0
                    visible: imgB.status === Image.Ready
                    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰎇"
                    color: root.themeAccent
                    opacity: 0.7
                    font.pixelSize: 32
                    visible: imgA.status !== Image.Ready && imgB.status !== Image.Ready
                }

                Rectangle {
                    anchors.fill: parent
                    radius: artContainer.radius
                    color: "transparent"
                    antialiasing: true
                    border {
                        width: 1
                        color: "#33ffffff"
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                clip: true

                Text {
                    Layout.fillWidth: true
                    text: root.activePlayer?.trackTitle ?? "Now playing"
                    color: root.themeFg
                    elide: Text.ElideRight
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 17
                        weight: Font.Medium
                        letterSpacing: 0.2
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: root.activePlayer?.trackArtist ?? "Unknown artist"
                    color: root.themeSecond
                    opacity: 0.65
                    elide: Text.ElideRight
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: 12
                        letterSpacing: 0.3
                    }
                }
            }
        }

        Rectangle {
            id: progressBar

            Layout.fillWidth: true
            height: progressMouse.containsMouse ? 7 : 4
            radius: 3
            color: progressMouse.containsMouse ? "#2effffff" : "#1cffffff"

            property real currentPos: root.activePlayer ? root.activePlayer.position : 0

            Behavior on height { NumberAnimation { duration: 160; easing.type: Easing.OutQuart } }
            Behavior on color { ColorAnimation { duration: 160 } }

            Timer {
                interval: 500
                repeat: true
                running: root.isPlaying && root.visible
                onTriggered: {
                    if (root.activePlayer)
                        progressBar.currentPos = root.activePlayer.position
                }
            }

            Rectangle {
                width: parent.width * Math.min(1.0, (root.activePlayer && root.activePlayer.length > 0
                    ? progressBar.currentPos / root.activePlayer.length
                    : 0))
                height: parent.height
                radius: parent.radius
                color: root.themeAccent

                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
            }

            MouseArea {
                id: progressMouse

                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: (mouse) => {
                    if (root.activePlayer && root.activePlayer.length > 0) {
                        const newPos = (mouse.x / width) * root.activePlayer.length
                        root.activePlayer.position = newPos
                        progressBar.currentPos = newPos
                    }
                }
            }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 48
            spacing: 38

            PlayerIconButton {
                icon: "󰒮"
                themeAccent: root.themeAccent
                themeFg: root.themeFg
                onClicked: root.activePlayer?.previous()
            }

            Rectangle {
                id: playButton

                property bool localPlaying: root.isPlaying

                width: 48
                height: 48
                radius: 14
                color: root.themeAccent
                scale: playMouse.pressed ? 0.92 : (playMouse.containsMouse ? 1.06 : 1.0)

                Connections {
                    target: root
                    function onIsPlayingChanged() { playButton.localPlaying = root.isPlaying }
                }

                Behavior on color { ColorAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on scale { SpringAnimation { spring: 4; damping: 0.38 } }

                Text {
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: playButton.localPlaying ? 0 : 2
                    text: playButton.localPlaying ? "󰏤" : "󰐊"
                    color: root.themeRawBg
                    opacity: 0.9
                    font.pixelSize: 20
                }

                MouseArea {
                    id: playMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        playButton.localPlaying = !playButton.localPlaying
                        root.activePlayer?.togglePlaying()
                    }
                }
            }

            PlayerIconButton {
                icon: "󰒭"
                themeAccent: root.themeAccent
                themeFg: root.themeFg
                onClicked: root.activePlayer?.next()
            }
        }
    }
}
