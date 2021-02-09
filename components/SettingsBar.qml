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
        image: "/icons/pin-outline"
        imagePressed: "/icons/pin"

        tooltipText: qsTr("Pin application to stay always on top.")
    }

    IconButton {
        id: logButton

        enabled: telnetSender.connected

        anchors.horizontalCenter: parent.horizontalCenter

        image: "/icons/text-box-outline"

        tooltipText: qsTr("Open log file.")


        onClicked: controller.openExternal("logs/logs(" + controller.getHost().replace(':', '-') + ").txt")
    }

    IconButton {
        id: closeButton

        anchors.horizontalCenter: parent.horizontalCenter

        visible: pinButton.checked
        image: "/icons/close"

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
