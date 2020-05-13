import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import com.company.keystrokessender 1.0
import com.company.controller 1.0
import Colors 1.0
import QtQuick.Window 2.2

Window {
    id: root

    width: 700
    minimumWidth: 700
    height: 540

    flags: pinButton.checked ? (Qt.Window | Qt.WindowStaysOnTopHint) : Qt.Window

    visible: true
    title: qsTr("HHelper")

    KeystrokesSender{
        id: keysender
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
        modeSelector.checked = controller.isDevMode()
    }

    Item {
        id: contentPlaceholder

        height: root.height
        width: root.width

        Row {
            id: row

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: pinButton.checked ? 31 : 30
                topMargin: pinButton.checked ? 24 : 0
            }

            spacing: 20

            Column {
                id: slotSection

                spacing: 10

                Text {
                    text: "Target window:"
                    color: Colors.black
                    font.pointSize: 12
                }

                TextField {
                    id: targetWindow

                    width: slotSelector.width
                    height: 45
                    font.pointSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: controller.getTargetWindow()
                    renderType: Text.QtRendering
                    onTextChanged: {
                        keysender.setupTargetWindow(text)
                        controller.setTargetWindow(text)
                    }
                }

                Row {
                    id: slotSelector

                    spacing: 10

                    Button {
                        id: goSlotButton
                        text: "Go to slot:"
                        property var gotoSlot: []

                        onClicked: {
                            gotoSlot = ['launchGame ', slotName.text]
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

                Switch {
                    id: modeSelector

                    text: "DEV"
                    onCheckedChanged: {
                        keysender.devMode = checked;
                        controller.changeDevMode(checked);
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                spacing: 10

                Text {
                    text: "Timeskew:"
                    color: Colors.black
                    font.pointSize: 12
                }

                Slider {
                    id: slider

                    height: 45
                    width: 300
                    snapMode: "SnapAlways"
                    from: 0.1
                    to: 5
                    stepSize: 0.1
                    value: 1.0
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 10

                    TextField {
                        id: sliderValue

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

                        property var timeskew: []

                        onClicked: {
                            timeskew = ['9 ', slider.value.toFixed(1)]
                            keysender.sendKeystroke(timeskew)
                        }
                    }
                }
            }

            Column {
                spacing: 10

                IconButton {
                    id: pinButton

                    checkable: true
                    image: "res/pin-outline.png"
                    imagePressed: "res/pin.png"
                }

                IconButton {
                    id: saveConfigButton

                    image: "res/content-save-cog-outline.png"
                    imagePressed: "res/content-save-cog.png"

                    onClicked: controller.saveCurrentConfig()
                }

                IconButton {
                    id: closeButton

                    visible: pinButton.checked
                    image: "res/close.png"

                    onClicked: Qt.quit()
                }
            }
        }

        Rectangle {
            height: 1
            width: contentPlaceholder.width - 60
            anchors {
                bottom: buttonsPlaceholder.top
                horizontalCenter: contentPlaceholder.horizontalCenter
                bottomMargin: 15
            }

            color: "lightgrey"
        }

        Row {
            id: buttonsPlaceholder

            anchors {
                top: row.bottom
                left: contentPlaceholder.left
                right: contentPlaceholder.right
                bottom: contentPlaceholder.bottom
                leftMargin: 30
                topMargin: 40
            }

            spacing: 10

            Grid {
                id: grid

                spacing: 10

                Repeater {
                    id: repeater

                    anchors.fill: parent

                    model: controller.buttonModel

                    delegate: Rectangle {
                        id: test

                        width: 120
                        height: 40

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
                                onTriggered: controller.buttonModel.removeButton(index)
                            }

//                            MenuItem {
//                                text: "Edit"
//                                onTriggered: console.log( "TO DO" )
//                            }
                        }
                    }
                }
            }

            Button {
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
                font.pixelSize: 15
            }

            TextField {
                id: popupBtnName
                x: 80
                y: 20
                width: 170
                height: 35
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
                y: 65
                text: "Commands:"
                font.pixelSize: 13
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
                    x: -15
                    width: 200
                    height: 30
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
                x: 45
                y: 400
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
                x: 125
                y: 400
                width: 70
                text: "Reset"
                onClicked: {
                    popupBtnName.text = ""
                    buttonsList.stringArray = ["", ""]
                    buttonsList.updateModel()
                }
            }

            Button {
                x: 205
                y: 400
                width: 70
                text: "Exit"
                onClicked: popup.close()
            }
        }
    }
}
