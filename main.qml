import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0
import com.company.controller 1.0
import Colors 1.0

Window {
    id: root

    visible: true
    width: 800
    height: 700
    title: qsTr("HHelper")

    KeystrokesSender{
        id: keysender
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
        controller.init()
    }

    TextField {
        id: targetWindow
        x: 10
        y: 10
        width: 200
        height: 45
        topPadding: 8
        font.pointSize: 11
        bottomPadding: 16
        text: controller.getTargetWindow()
        renderType: Text.QtRendering
        onTextChanged: {
            keysender.setupTargetWindow(text)
            controller.setTargetWindow(text)
        }
    }

    Button {
        id: buttonSetTargetWindow
        x: 220
        y: 12
        text: "Set as default"
        onClicked: {
            controller.saveCurrentConfig()
        }
    }

    Row {
        id: row1
        spacing: 10
        x: 70
        y: 80

        Button {
            id: goSlotButton
            text: "Go to slot:"
            property var args: ['`', 'launchGame ', slotName.text, 'VK_RETURN', '`']
            onClicked: {
                keysender.sendKeystroke(args)
            }
        }
        TextField {
            id: slotName
            width: 150
            height: 40
            topPadding: 10
            font.pointSize: 11
            bottomPadding: 14
            text: controller.getSlotName()
            renderType: Text.QtRendering
            onTextChanged: {
                controller.setSlotName(text)
            }
        }
    }

    Row {
        id: row2
        spacing: 10
        x: 70
        y: 150

        Grid {
            id: grid
            spacing: 10
            Repeater {
                id: repeater
                anchors.fill: parent

                model: controller.buttonModel
                delegate: Rectangle {
                    id: test
                    color: mouseArea.pressed ? Colors.mist : Colors.stone
                    Text {
                        anchors.fill:parent
                        text: buttonName
                        color: Colors.textPrimary
                        font.pointSize: 9
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.margins: {
                            left: 10
                            right: 10
                        }
                    }
                    width: 120
                    height: 40
                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button == Qt.LeftButton) {
                                keysender.sendKeystroke(buttonArgs)
                            }

                            if (mouse.button === Qt.RightButton){
                                contextMenu.popup()
                            }
                        }
                        onPressAndHold: {
                            if (mouse.source === Qt.MouseEventNotSynthesized)
                                contextMenu.popup()
                        }
                    }
                    Menu {
                        id: contextMenu
                        MenuItem {
                            text: "Remove"
                            onTriggered: {
                               controller.buttonModel.removeButton(index)
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: popup
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        width: parent.width / 2
        height: parent.height - 50
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnReleaseOutside

        Text {
            x: parent.width / 2 - width / 2
            y: 85
            text: "Commands:"
            font.pixelSize: 15
        }

        ListView {
            id: buttonsList
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2 - 30
            width: parent.width / 2
            height: parent.height / 2
            property var stringArray:  ["", ""]
            property var buttonName: ""
            model: stringArray

            function updateModel() {
                model = 0
                model = stringArray
                currentIndex = stringArray.length - 1
            }

            delegate: TextField {
                x: -30
                width: 260
                height: 40
                topPadding: 10
                font.pointSize: 9
                bottomPadding: 14
                text: modelData
                renderType: Text.QtRendering

                onAccepted: {
                    if ( (buttonsList.stringArray[index] !== "") && (index == (buttonsList.stringArray.length - 1))) {
                        buttonsList.stringArray.push("")
                        buttonsList.updateModel()
                    }
                }
                onTextChanged: {
                    buttonsList.stringArray[index] = text
                }
            }
        }
        Text {
            x: 40
            y: 25
            text: "Name:"
            font.pointSize: 11
        }

        TextField {
            x: 100
            y: 20
            width: 200
            height: 40
            topPadding: 8
            font.pointSize: 11
            bottomPadding: 16
            text: buttonsList.buttonName
            renderType: Text.QtRendering
            onTextChanged: {
                buttonsList.buttonName = text
            }
        }

        Button {
            x: 200
            y: 500
            width: 130
            text: "Exit"
            onClicked: popup.close()
        }

        Button {
            x: 60
            y: 500
            width: 110
            text: "Save"
            onClicked: {
                if (buttonsList.buttonName !== "")
                {
                    controller.buttonModel.addButton(buttonsList.buttonName, buttonsList.stringArray)
                }
            }
        }

    }

    Button {
        x: 600
        y: 150
        text: "Add button"
        contentItem: Text {
            text: parent.text
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        palette {
            button: Colors.autumn
        }
        onClicked: {
            popup.open()
        }
    }
}
