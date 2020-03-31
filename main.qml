import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Row {
        id: row1
        spacing: 10
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
