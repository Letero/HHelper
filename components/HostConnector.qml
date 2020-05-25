import QtQuick 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.12

import "../controls"

Column {
    id: slotSection

    spacing: 10

    property alias hostAddress: hostAddress.text

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5

        TextField {
            id: hostAddress

            width: hostBox.width - saveHostButton.width - parent.spacing - 2 * hostBox.padding
            height: 30
            selectByMouse: true
            font.pointSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            placeholderText: "localhost"
            renderType: Text.QtRendering
            text: controller.getHost()
            onTextChanged: controller.setHost(text)
        }

        Button {
            id: saveHostButton

            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: hostAddress.height
            text: qsTr("Save")
            font.pixelSize: 14

            onClicked: {
                saveHostPopup.open()
            }

            SaveHostPopup {
                id: saveHostPopup

                addressText: hostAddress.text

                onSaveClicked: {
                    controller.hostModel.addHost(addressText, nameText)
                    hostCombo.updateIndex()
                }
                onOpened: nameText = ""
            }
        }
    }

    ComboBox {
        id: hostCombo

        width: hostBox.width - 2 * hostBox.padding
        model: controller.hostModel
        enabled: count > 0
        property string option: qsTr("option")
        property string options: qsTr("options")
        property string defaultText: count == 0
                                     ? qsTr("Not any saved")
                                     : qsTr("Choose saved") + " (" + count + " " + (count > 1 ? options : option) + ")"

        displayText: currentIndex >= 0 ? currentText : defaultText
        valueRole: "address"
        textRole: "label"
        popup.width: 400

        currentIndex: -1

        // NOTE: when done in onTextChanged of hostAddress it had been breaking the hostCombo,
        // problably because of setting a property before the latter was completed
        Connections {
            target: hostAddress
            function onTextChanged() { hostCombo.updateIndex() }
        }
        Component.onCompleted: { updateIndex() }
        function updateIndex() { hostCombo.currentIndex = controller.hostModel.findHostIndex(hostAddress.text) }

        onActivated: hostAddress.text = currentValue

        delegate: ItemDelegate {
            id: itemDelegate

            height: 40
            width: parent.width
            contentItem: Rectangle {
                anchors.fill: parent
                border {
                    color: Universal.accent
                    width: 2
                }

                color: parent.hovered ? "gray" : Universal.background

                MaterialText {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: 12
                    text: label
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                Button {
                    id: removeButton

                    anchors {
                        right: parent.right
                        rightMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    text: qsTr("Remove")
                    onClicked: {
                        controller.hostModel.removeHost(index)
                    }
                }

                Button {
                    id: editButton

                    anchors {
                        right: removeButton.left
                        rightMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    text: qsTr("Edit")

                    onClicked: editHostPopup.open()

                    SaveHostPopup {
                        id: editHostPopup

                        addressText: address
                        nameText: name

                        onSaveClicked: {
                            controller.hostModel.editHost(index, addressText, nameText)
                        }
                    }
                }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 2

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            leftPadding: 60

            Image {
                id: statusIcon
                height: statusText.height
                width: height
                source: telnetSender.connected ? "qrc:/res/check.png" : "qrc:/res/disconnect.png"

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: telnetSender.connected ? "green" : "red"
                }
            }

            Text {
                id: statusText

                anchors.verticalCenter: parent.verticalCenter
                width: hostAddress.width - statusIcon.width - 60
                font.pointSize: 12
                verticalAlignment: Text.AlignVCenter
                text: telnetSender.connected ? qsTr("Connected") : qsTr("Not connected")
                color: telnetSender.connected ? "green" : "red"
            }
        }

        Button {
            anchors.verticalCenter: parent.verticalCenter
            width: saveHostButton.width
            height: 30
            text: qsTr("Retry")
            font.pixelSize: 14
            onClicked: {
                telnetSender.connectToTelnet()
            }
        }
    }
}
