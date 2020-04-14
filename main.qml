import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0
import com.company.jsonparser 1.0

Window {
    id: root

    visible: true
    width: 640
    height: 480
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
        Button {
            text: "Add button"
            onClicked: buttonModel.addButton("klik", ['test', 'srest', 'agrest'])
        }
    }




}
