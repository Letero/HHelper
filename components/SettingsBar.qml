import QtQuick 2.0
import QtQuick.Controls 2.12

import "../controls"

Column {
    id: root
    spacing: 10

    signal themeChanged(var checked)

    Component.onCompleted: {
        themeSwitch.checked = controller.isDarkTheme()
    }

    property alias pinned: pinButton.checked

    IconButton {
        id: pinButton

        anchors.horizontalCenter: parent.horizontalCenter

        checkable: true
        image: "qrc:/res/pin-outline.png"
        imagePressed: "qrc:/res/pin.png"

        tooltipText: qsTr("Pin application to stay always on top.")
    }

    IconButton {
        id: closeButton

        anchors.horizontalCenter: parent.horizontalCenter

        visible: pinButton.checked
        image: "qrc:/res/close.png"

        tooltipText: qsTr("Close application.")

        onClicked: Qt.quit()
    }

    Column {
        spacing: 0

        MaterialText {
            text: "Dark theme"
            font.pixelSize: 13
            verticalAlignment: Qt.AlignVCenter
        }

        Switch {
            id: themeSwitch

            height: 30

            onCheckedChanged: {
                themeChanged(checked)
            }
        }
    }
}
