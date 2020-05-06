import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0
import com.company.controller 1.0
import Colors 1.0

Window {
    id: root

    visible: true
    width: 700
    height: 720
    title: qsTr("HHelper")

    KeystrokesSender{
        id: keysender
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
    }

    Text {
        anchors.fill:parent
        text: "Target window:"
        topPadding: 10
        leftPadding: 30
        color: Colors.black
        font.pointSize: 12
    }

    TextField {
        id: targetWindow
        x: 30
        y: 40
        width: 200
        height: 45
        font.pointSize: 11
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: controller.getTargetWindow()
        renderType: Text.QtRendering
        onTextChanged: {
            keysender.setupTargetWindow(text)
            controller.setTargetWindow(text)
            console.log(controller.isDev())
        }
    }

    Row {
        id: row1
        spacing: 10
        x: 30
        y: 110

        Button {
            id: goSlotButton
            text: "Go to slot:"
            property var gotoSlot: []
            onClicked: {
                if (controller.isDev()) {
                    gotoSlot = ['`', 'launchGame ', slotName.text, 'VK_RETURN', '`']
                } else {
                    gotoSlot = ['launchGame ', slotName.text, 'VK_RETURN']
                }

                keysender.sendKeystroke(gotoSlot)
            }
        }
        TextField {
            id: slotName
            width: 150
            height: 40
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 11
            text: controller.getSlotName()
            renderType: Text.QtRendering
            onTextChanged: {
                controller.setSlotName(text)
            }
        }
    }

    Text {
        anchors.fill:parent
        text: "Timeskew:"
        topPadding: 10
        leftPadding: 480
        color: Colors.black
        font.pointSize: 12
    }

    Slider {
        id: slider
        x: 380
        y: 30
        width: 300
        snapMode: "SnapAlways"
        from: 0.1
        to: 5
        stepSize: 0.1
        value: 1.0
    }

    TextField {
        id: sliderValue
        x: 440
        y: 70
        width: 60
        height: 40
        font.pointSize: 9
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: slider.value.toFixed(1)
        renderType: Text.QtRendering
        onTextChanged: {
            slider.value = parseFloat(text)
        }
    }

    Button {
        text: "Set"
        width: 60
        height: 40
        x: 515
        y: 70
        property var timeskew: []
        onClicked: {
            if (controller.isDev()) {
                timeskew = ['`', '9 ', slider.value.toFixed(1), 'VK_RETURN', '`']
            } else {
                timeskew = ['9 ', slider.value.toFixed(1), 'VK_RETURN']
            }
            keysender.sendKeystroke(timeskew)
        }
    }

    Row {
        id: row2
        spacing: 10
        x: 30
        y: 170

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
            x: 20
            y: 25
            text: "Name:"
            font.pointSize: 11
        }

        TextField {
            id: popupBtnName
            x: 80
            y: 20
            width: 200
            height: 40
            font.pointSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: buttonsList.buttonName
            renderType: Text.QtRendering
            onTextChanged: {
                buttonsList.buttonName = text
            }
        }


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
                font.pointSize: 9
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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

        Button {
            x: 35
            y: 530
            width: 70
            text: "Add"
            onClicked: {
                if (buttonsList.buttonName !== "")
                {
                    controller.buttonModel.addButton(buttonsList.buttonName, buttonsList.stringArray)
                }
            }
        }

        Button {
            x: 115
            y: 530
            width: 70
            text: "Reset"
            onClicked: {
                popupBtnName.text = ""
                buttonsList.stringArray = ["", ""]
                buttonsList.updateModel()
            }
        }

        Button {
            x: 195
            y: 530
            width: 70
            text: "Exit"
            onClicked: popup.close()
        }

    }

    Button {
        x: 560
        y: 170
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

    Button {
        x: 560
        y: 220
        text: "Save config"
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
            controller.saveCurrentConfig()
        }
    }

    Button {
        x: 560
        y: 270
        text: "Exit"
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
            Qt.callLater(Qt.quit)
        }
    }
}
