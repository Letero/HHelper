import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0
import com.company.jsonparser 1.0
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

    JsonParser {
        id: parser
    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
        buttonModel.init(parser.getButtonsData())
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
        text: parser.getTargetWindowName()
        renderType: Text.QtRendering
        onTextChanged: {
            keysender.setupTargetWindow(text)
            parser.setTargetWindowName(text)
        }
    }

    Button {
        id: buttonSetTargetWindow
        x: 220
        y: 12
        text: "Set as default"
        onClicked: {
            parser.saveCurrentConfig()
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
            text: parser.getSlotName()
            renderType: Text.QtRendering
            onTextChanged: {
                parser.setSlotName(text)
            }
        }
    }

    Row {
        id: row2
        spacing: 10
        x: 70
        y: 150

        Grid {
            spacing: 10
            Repeater {
                anchors.fill: parent

                model: buttonModel
                delegate: Button {
                    text: buttonName
                    width: 100
                    onClicked: {
                        keysender.sendKeystroke(buttonArgs)
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
            y: 20
            text: "Commands:"
            font.pixelSize: 15
        }

        Item {
            width: parent.width
            height: parent.height
            Button {
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: {
                        top: 15
                        right: 15
                    }
                }
                text: "Exit"
                onClicked: popup.close()
            }
        }

        ListView {
            id: inputList
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            width: parent.width / 2
            height: parent.height / 2
            property var stringArray:  ["", ""]
            model: stringArray

            function updateModel() {
                model = 0
                model = stringArray
                currentIndex = stringArray.length - 1
            }

            delegate: TextField {
                width: 150
                height: 40
                topPadding: 10
                font.pointSize: 11
                bottomPadding: 14
                text: modelData
                renderType: Text.QtRendering

                onAccepted: {
                    if ( (inputList.stringArray[index] !== "") && (index == (inputList.stringArray.length - 1))) {
                        inputList.stringArray.push("")
                        inputList.updateModel()
                    }
                }
                onTextChanged: {
                    inputList.stringArray[index] = text
                }
            }
        }

        Button {
            x: 100
            y: 500
            text: "Save"
            onClicked: {
                buttonModel.addButton("klik", inputList.stringArray)
            }
        }

    }

    Button {
        x: 550
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
