import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import com.company.keystrokessender 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    KeystrokesSender{
        id: keysender
    }

    TextField {
        id: serverField1
        x: 15
        y: 46
        width: 120
        height: 45
        topPadding: 8
        font.pointSize: 14
        bottomPadding: 16
        placeholderText: "Server Ip"
        renderType: Text.QtRendering
        onTextChanged: keysender.setupTargetWindow(text)
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
                keysender.sendKeystroke("`")
                keysender.sendKeystroke("disconnect")
                keysender.sendKeystroke("VK_RETURN")
                keysender.sendKeystroke("`")
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
            }
        }

        Button {
            id: button3
            text: "test"
            onClicked: {
                keysender.sendKeystroke("`aaaaaaaaaaaaaaaaaaaa")
            }
        }
    }
}
