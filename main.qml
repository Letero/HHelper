import QtQuick 2.14
import QtQuick.Controls 2.14
import com.company.TelnetSender 1.0
import com.company.controller 1.0
import Colors 1.0
import QtQuick.Window 2.2
import QtQuick.Controls.Universal 2.12
import QtQuick.Layouts 1.14

import "./controls"
import "./components"

Window {
    id: root

    minimumWidth: 380
    minimumHeight: 600
    width: controller.getWidth()
    height: controller.getHeight()

    onWidthChanged: {
        controller.setWidth(root.width)
    }

    onHeightChanged: {
        controller.setHeight(root.height)
    }

    flags: settingsBar.pinned ? (Qt.Window | Qt.WindowStaysOnTopHint) : Qt.Window

    visible: true
    title: qsTr("Telnet Helper")

    color: Universal.background
    Universal.theme: Universal.Light

    Universal.accent: Universal.theme == Universal.Light ? "#f2a365" : "#30475e"
    Universal.foreground: Universal.theme == Universal.Light ? "#222831" : "#ececec"
    Universal.background: Universal.theme == Universal.Light ? "#ececec" : "#222831"

    TelnetSender{
        id: telnetSender

        host: hostConnector.hostAddress
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        telnetSender.connectToTelnet()
    }

    Item {
        Timer {
            interval: 500; running: true; repeat: true
            onTriggered:
            {
                if (!telnetSender.connected) {
                    telnetSender.connectToTelnet()
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        preventStealing: true
        onPressed: {
            forceActiveFocus()
        }
    }
    // @disable-check M16
    onClosing: {
        controller.saveCurrentConfig()
    }
}
