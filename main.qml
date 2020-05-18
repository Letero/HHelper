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

            spacing: 10

            Column {
                id: slotSection

                spacing: 10

                Text {
                    text: qsTr("Target window:")
                    color: Colors.black
                    font.pointSize: 12
                }

                TextField {
                    id: targetWindow

                    width: slotSelector.width
                    height: 45
                    selectByMouse: true
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

                        width: 80
                        text: qsTr("Go to slot:")
                        property var gotoSlot: []

                        onClicked: {
                            gotoSlot = ['launchGame ' + slotName.text]
                            keysender.sendKeystroke(gotoSlot)
                        }
                    }

                    TextField {
                        id: slotName
                        width: 150
                        height: 40
                        selectByMouse: true
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
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                spacing: 10

                Text {
                    text: qsTr("Timeskew:")
                    color: Colors.black
                    font.pointSize: 12
                }

                Slider {
                    id: slider

                    height: 45
                    width: 220
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
                        selectByMouse: true
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
                            timeskew = ['9 ' + slider.value.toFixed(1)]
                            keysender.sendKeystroke(timeskew)
                        }
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "DEV"
                    verticalAlignment: Qt.AlignVCenter
                }

                Switch {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: modeSelector

                    height: 40

                    onCheckedChanged: {
                        keysender.devMode = checked;
                        controller.changeDevMode(checked);
                    }
                }
            }

            Column {
                spacing: 10

                IconButton {
                    id: pinButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    checkable: true
                    image: "res/pin-outline.png"
                    imagePressed: "res/pin.png"

                    tooltipText: qsTr("Pin application to stay always on top.")
                }

                IconButton {
                    id: saveConfigButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    image: "res/content-save-cog-outline.png"
                    imagePressed: "res/content-save-cog.png"

                    tooltipText: qsTr("Save changes to config file.")

                    onClicked: controller.saveCurrentConfig()
                }

                IconButton {
                    id: closeButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    visible: pinButton.checked
                    image: "res/close.png"

                    tooltipText: qsTr("Close application.")

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
                                text: qsTr("Edit")
                                onTriggered: popup.openEdit(index, buttonName, buttonArgs)
                            }

                            MenuItem {
                                text: qsTr("Remove")
                                onTriggered: controller.buttonModel.removeButton(index)
                            }
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
                onClicked: popup.open()
            }
        }

        ButtonEditPopup {
            id: popup
        }
    }
}
