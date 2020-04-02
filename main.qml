import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0


Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("HHelper")

    KeystrokesSender{
        id: keysender
    }

    QMLJsonParser {
        id: parser
    }

    Button {
        id: test1
        x: 400
        y: 12
        text: "test"
        onClicked: {
            parser.jso()
        }

    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
    }

    TextField {
        id: targetWindow
        x: 10
        y: 10
        width: 200
        height: 45
        topPadding: 8
        font.pointSize: 14
        bottomPadding: 16
        text: parser.getTargetName()
        renderType: Text.QtRendering
        onTextChanged: keysender.setupTargetWindow(text)
    }
    Button {
        id: buttonSetTarget
        x: 220
        y: 12
        text: "Set as default"
        onClicked: {
            parser.setTargetName(targetWindow.text)
        }
    }
    Row {
        id: row1
        spacing: 10
        x: 100
        y: 100
        Button {
            id: button1
            text: "Disconnect"
            onClicked: {
                keysender.sendKeystroke("VK_BACK_QUOTE")
                keysender.sendKeystroke("disconnect")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("VK_BACK_QUOTE")
                keysender.sendKeystroke("VK_RETURN")
            }
        }

        Button {
            id: button2
            text: "+10 lev +1000 diamonds"
            onClicked: {
                keysender.sendKeystroke("`")
                keysender.sendKeystroke("server playerChange level 10")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("server playerChange diamonds 1000")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("skipRewardPopups true")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("discon")
                keysender.sendKeystroke("nect")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("`")
                keysender.sendKeystroke("VK_RETURN")
            }
        }

        Button {
            id: button3
            text: "GoCats"
            onClicked: {
                keysender.sendKeystroke("`launchGame SlotsBigCats")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("`")
                keysender.sendKeystroke("VK_RETURN")
            }
        }
    }
}
