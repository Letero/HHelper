import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.12

import "./controls"

Popup {
    id: root

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2
    width: 0.6 * parent.width
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

    onOpened: {
        popupBtnName.forceActiveFocus()
        buttonsList.anyText = false
    }

    onClosed: {
        clearPopup()
        root.editMode = false
    }

    Button {
        id: addCommandButton

        y: 88
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
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 30
            rightMargin: 60
        }

        height: 0.94 * parent.height

        spacing: 15

        Column {
            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: parent.width - 30

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

                onAccepted: saveButton.onClicked()
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
                x: 15
            }

            ListView {
                id: buttonsList

                width: parent.width
                height: parent.height - listHeader.height
                clip: true

                property var stringArray:  [""]
                property bool anyText: false

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

                delegate: Item {
                    width: scrollBar.visible ? parent.width - 15 : parent.width
                    height: 30

                    MouseArea {
                        id: commandMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }


                    IconButton {
                        id: newCommandBtn

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        image: "qrc:/res/minus.png"

                        height: parent.height
                        width: height

                        visible: (commandMouseArea.containsMouse || commandText.hovered || hovered) && index > 0

                        onClicked: {
                            buttonsList.stringArray.splice(index, 1)
                            buttonsList.updateModel()
                        }
                    }

                    TextField {
                        id: commandText

                        anchors {
                            left: newCommandBtn.right
                            right: parent.right
                        }

                        selectByMouse: true
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
                        renderType: Text.QtRendering

                        onTextChanged: {
                            buttonsList.stringArray[index] = text

                        function checkTexts()
                        {
                            for (var ind = 0; ind < buttonsList.stringArray.length; ++ind)
                            {
                                if (buttonsList.stringArray[ind] !== "") return true
                            }

                            return false
                        }

                        buttonsList.anyText = checkTexts()
                        }

                        onAccepted: saveButton.onClicked()
                    }
                }
            }
        }

        RowLayout {
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 30

            spacing: 10

            Button {
                id: saveButton
                Layout.fillWidth: true
                text: root.editMode ? "Save" : "Add"
                enabled: buttonsList.anyText && popupBtnName.text !== ""

                onClicked: {
                    if (popupBtnName.text !== "")
                    {
                        if (root.editMode) {
                            controller.buttonModel.editButton(root.currentButtonIndex, popupBtnName.text, buttonsList.stringArray)
                            root.close()
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
