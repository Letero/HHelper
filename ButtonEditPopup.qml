import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.12


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
        buttonsList.stringArray = [""]
        buttonsList.updateModel()
    }

    onClosed: {
        clearPopup()
        root.editMode = false
    }


    Button {
        id: addCommandButton

        y: 108
        anchors.left: layout.right

        width: 35
        height: 35

        Image {
            anchors.centerIn: parent.Center
            source: "res/plus.png"

            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: addCommandButton.pressed ? Universal.background : Universal.foreground
            }

        }

        onClicked: {
            buttonsList.stringArray.push("")
            buttonsList.updateModel()
        }

        background: Item {
        }

        ToolTip.delay: 1000
        ToolTip.visible: hovered
        ToolTip.text: "Add text field."
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        height: 0.9 * parent.height
        width:  0.6 * parent.width

        spacing: 15

        Column {
            Layout.preferredWidth: parent.width

            MaterialText {
                width: parent.width
                text: "Name:"
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
            }

            TextField {
                id: popupBtnName

                height: 35
                width: parent.width

                selectByMouse: true
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                renderType: Text.QtRendering
            }
        }

        Column {
            id: listHolder

            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            MaterialText {
                id: listHeader

                text: "Commands:"
                font.pointSize: 12
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            ListView {
                id: buttonsList

                width: parent.width
                height: parent.height - listHeader.height
                clip: true

                property var stringArray:  [""]

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
