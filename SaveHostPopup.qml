import QtQuick 2.14
import QtQuick.Controls 2.14

Popup {
    id: root

    width: 300

    property alias addressText: addressField.text
    property alias nameText: nameField.text

    signal saveClicked()

    contentItem: Column {
        anchors {
            fill: parent
            margins: 8
        }

        spacing: 8

        MaterialText {
            width: parent.width
            text: qsTr("Name: ")

            font.pointSize: 12
        }
        TextField {
            id: nameField

            width: parent.width
            font.pointSize: 12
        }
        Item {
            height: 8
            width: height
        }

        MaterialText {
            width: parent.width
            text: qsTr("Address: ")

            font.pointSize: 12
        }
        TextField {
            id: addressField

            width: parent.width
            font.pointSize: 12
        }

        Button {
            enabled: nameField.text && addressField.text
            height: addressText.height
            text: qsTr("Save")
            font.pointSize: 14
            onClicked: {
                root.saveClicked()
                root.close()
            }
        }
    }
}
