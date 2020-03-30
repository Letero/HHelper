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

        Button {
            id: button1
            text: "button1"
            onClicked: {
                keysender.sendKeystroke("`")
            }
        }

        Button {
            id: button2
            text: "button2"
            onClicked: {

            }
        }
    }
}
