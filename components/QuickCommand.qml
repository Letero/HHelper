import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

import "../controls"

Row {
    id: root

    spacing: 16

    readonly property int itemHeight: 32

    ComboBox {
        id: quickCommand

        width: parent.width - sendQuickCommandButton.width - root.spacing
        height: 32
        font.pointSize: 12
        editable: true
        onAccepted: sendQuickCommandButton.onClicked()
        currentIndex: count - 1

        property string savedText: ""
        property bool allowRestore: false

        model: controller.commandModel
        indicator: Item {}
        popup: Popup {}

        onEditTextChanged: {
            if (currentIndex == count - 1 && editText == "" && allowRestore)
            {
                editText = savedText
                allowRestore = false
            }
        }

        Keys.onEscapePressed: {
            savedText = ""
            currentIndex = count - 1
            contentItem.clear()
        }

        Keys.onUpPressed: {
            event.accepted = false
            if (currentIndex == count - 1)
            {
                savedText = editText
            }
        }

        Keys.onDownPressed: {
            event.accepted = false
            if (currentIndex == count - 2)
            {
                allowRestore = true
            }

        }

        contentItem: TextField {
            selectByMouse: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 12
            renderType: Text.QtRendering
            text: quickCommand.editText
        }

        Item {
            id: commandHistory

            property int padding: 16

            width: parent.width + padding * 2
            height: itemHeight * (Math.min(quickCommand.count, 8) - 1) + padding * 2

            x: -padding
            y: -height + padding
            visible: quickCommand.activeFocus && quickCommand.currentIndex < quickCommand.count - 1

            onVisibleChanged: commandsList.contentY = commandsList.contentHeight - commandsList.height

            clip: true

            ListView {
                id: commandsList

                anchors {
                    fill: parent
                    margins: parent.padding
                    bottomMargin: parent.padding - itemHeight
                }

                Connections {
                    target: quickCommand
                    onCurrentIndexChanged: {
                        if (quickCommand.currentIndex * itemHeight < commandsList.contentY)
                        {
                            commandsList.contentY -= itemHeight
                        }
                        else if (quickCommand.currentIndex * itemHeight > commandsList.contentY + commandsList.height - itemHeight * 2)
                        {
                            commandsList.contentY += itemHeight
                        }
                    }
                }

                model: quickCommand.model
                interactive: false

                delegate: ItemDelegate {
                    id: delegate
                    height: itemHeight
                    width: parent.width
                    visible: index < commandsList.count - 1

                    contentItem: Rectangle {
                        anchors.fill: parent
                        border {
                            color: Universal.accent
                            width: 2
                        }
                        color: parent.hovered ? "grey"
                                              : quickCommand.currentIndex == index
                                                ? Universal.accent : Universal.background

                        MaterialText {
                            anchors {
                                fill: parent
                                leftMargin: 8
                            }
                            text: role ? role : ""
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: quickCommand.currentIndex = index
                        }
                    }
                }
            }
        }
    }

    Button {
        id: sendQuickCommandButton

        enabled: /\S/.test(quickCommand.editText)
        text: "Send"
        onClicked: {
            if (!enabled)
                return

            var trimmed = quickCommand.editText.trim()
            quickCommand.savedText = ""
            controller.commandModel.saveCommand(trimmed)
            telnetSender.send(trimmed)
            quickCommand.currentIndex = quickCommand.count - 1
            quickCommand.editText = ""
        }
    }
}
