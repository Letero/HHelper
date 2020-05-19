import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

Popup {
    id: root

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    width: parent.width / 2
    height: parent.height - 50
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape

    property int currentButtonIndex: 0
    property bool editMode: false

    function openEdit(index, buttonName, args) {
        root.currentButtonIndex = index
        popupBtnName.text = buttonName
        buttonsList.stringArray = args
        buttonsList.updateModel()
        root.editMode = true

        root.open()
    }

    function clearPopup() {
        popupBtnName.text = ""
        buttonsList.stringArray = ["", ""]
        buttonsList.updateModel()
    }

    onClosed: {
        clearPopup()
        root.editMode = false
    }

    Button {
        x: 280
        y: 105
        width: 35
        height: 35
        Image {
            anchors.centerIn: parent.Center
            source: "res/plus.png"
        }

        onClicked: {
            buttonsList.stringArray.push("")
            buttonsList.updateModel()
        }
        background: Rectangle {
            color: "transparent"
        }
        ToolTip.delay: 1000
        ToolTip.visible: hovered
        ToolTip.text: "Add text field."
    }

    ColumnLayout {
        anchors.centerIn: parent
        height: 0.9 * parent.height
        width:  0.6 * parent.width

        spacing: 15

        Column {
            Layout.preferredWidth: parent.width

            Text {
                width: parent.width
                text: "Name:"
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: popupBtnName

                height: 35
                width: parent.width

                selectByMouse: true
                font.pointSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering
            }
        }

        Column {
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            Text {
                id: listHeader

                text: "Commands:"
                font.pixelSize: 13
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            ListView {
                id: buttonsList

                width: parent.width
                height: parent.height - listHeader.height
                clip: true

                property var stringArray:  ["", ""]

                model: stringArray

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar

                    policy: ScrollBar.AlwaysOn
                    visible: parent.contentHeight > parent.height
                }

                function updateModel() {
                    model = 0
                    model = stringArray
                    currentIndex = stringArray.length - 1
                }

                delegate: TextField {
                    width: scrollBar.visible ? parent.width - 10 : parent.width
                    height: 30
                    selectByMouse: true
                    font.pointSize: 9
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: modelData
                    renderType: Text.QtRendering

                    onTextChanged: {
                        buttonsList.stringArray[index] = text
                    }
                }
            }
        }

        RowLayout {
            Layout.preferredWidth: parent.width

            spacing: 10

            Button {
                Layout.fillWidth: true
                text: root.editMode ? "Save" : "Add"
                onClicked: {
                    if (popupBtnName.text !== "")
                    {
                        if (root.editMode) {
                            controller.buttonModel.editButton(root.currentButtonIndex, popupBtnName.text, buttonsList.stringArray)
                        } else {
                            controller.buttonModel.addButton(popupBtnName.text, buttonsList.stringArray)
                        }
                    }
                }
            }

            Button {
                Layout.fillWidth: true
                text: "Reset"
                onClicked: root.clearPopup()
            }

            Button {
                Layout.fillWidth: true
                text: "Cancel"
                onClicked: popup.close()
            }
        }
    }
}
