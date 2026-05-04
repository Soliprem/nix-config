import QtQuick

Item {
    id: root

    property var buttonModel
    property color themeAccent
    property color themeSecond
    property color themeFg
    property color themeFresh
    property color themeWarm
    readonly property int buttonSize: 50
    readonly property int buttonSpacing: 12
    readonly property int buttonCount: buttonModel ? buttonModel.count : 0
    readonly property int staticTopRowCount: Math.ceil(buttonCount / 2)
    readonly property bool canScroll: buttonCount > 10

    signal requestCmd(var cmdArray)
    signal requestHide()
    signal requestToggleDnd()

    function colorForRole(role) {
        switch (role) {
            case "warm": return themeWarm
            case "fresh": return themeFresh
            case "accent": return themeAccent
        }
        return themeSecond
    }

    function commandFor(binary, args) {
        if (args === "")
            return [binary]

        return [binary].concat(args.split(" ").filter((arg) => arg !== ""))
    }

    function staticRowFor(index) {
        return index < staticTopRowCount ? 0 : 1
    }

    function staticRowCountFor(row) {
        return row === 0 ? staticTopRowCount : buttonCount - staticTopRowCount
    }

    function staticRowStartFor(row) {
        return row === 0 ? 0 : staticTopRowCount
    }

    function staticButtonX(index) {
        const row = staticRowFor(index)
        const rowCount = staticRowCountFor(row)
        const rowWidth = rowCount * buttonSize + Math.max(0, rowCount - 1) * buttonSpacing
        return (width - rowWidth) / 2 + (index - staticRowStartFor(row)) * (buttonSize + buttonSpacing)
    }

    function staticButtonY(index) {
        return staticRowFor(index) * (buttonSize + buttonSpacing)
    }

    function activateButton(action, binary, args) {
        switch (action) {
            case "dnd":
                root.requestToggleDnd()
                break
            default:
                root.requestHide()
                root.requestCmd(root.commandFor(binary, args))
        }
    }

    Item {
        anchors.fill: parent
        visible: !root.canScroll

        Repeater {
            model: root.buttonModel

            delegate: SidebarActionButton {
                x: root.staticButtonX(index)
                y: root.staticButtonY(index)
                icon: model.icon
                action: model.action
                binary: model.binary
                args: model.args
                roleColor: root.colorForRole(model.color_role)
                themeFg: root.themeFg

                onClicked: root.activateButton(action, binary, args)
            }
        }
    }

    Flickable {
        anchors.fill: parent
        visible: root.canScroll
        anchors.topMargin: -10
        anchors.bottomMargin: -10
        anchors.leftMargin: -10
        anchors.rightMargin: -4
        clip: true
        interactive: root.canScroll
        flickableDirection: Flickable.HorizontalFlick
        boundsBehavior: root.canScroll ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        maximumFlickVelocity: 800
        flickDeceleration: 2500
        pixelAligned: true
        contentWidth: buttonGrid.implicitWidth + 20
        contentHeight: 132

        Grid {
            id: buttonGrid

            x: 10
            y: 10
            rows: 2
            spacing: 12
            flow: Grid.TopToBottom

            Repeater {
                model: root.buttonModel

                delegate: SidebarActionButton {
                    icon: model.icon
                    action: model.action
                    binary: model.binary
                    args: model.args
                    roleColor: root.colorForRole(model.color_role)
                    themeFg: root.themeFg

                    onClicked: root.activateButton(action, binary, args)
                }
            }
        }
    }
}
