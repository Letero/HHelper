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

    width: 720
    minimumWidth: 720
    maximumWidth: 720
    height: 600

    flags: settingsBar.pinned ? (Qt.Window | Qt.WindowStaysOnTopHint) : Qt.Window

    visible: true
    title: qsTr("HHelper")

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
        id: contentPlaceholder

        y: 5
        height: root.height - y
        width: root.width


        MouseArea {
            anchors.fill: parent

            onClicked: {
                focus = true
                console.log("doopsko")
            }
        }

        GridLayout {
            id: gridLayout

            rowSpacing: 10

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 10
            }

            columns: 3
            rows: 2


            GroupBox {
                id: hostBox

                title: qsTr("Host (address):")
                Layout.preferredWidth: 0.45 * contentPlaceholder.width

                HostConnector {
                    id: hostConnector
                }
            }

            GroupBox {
                title: qsTr("Language:")
                Layout.preferredWidth: 0.4 * contentPlaceholder.width
                Layout.fillHeight: true

                LanguageSelector {
                    anchors.centerIn: parent
                    enabled: telnetSender.connected
                }
            }

            GroupBox {
                title: ""

                Layout.rowSpan: 2
                Layout.fillHeight: true
                Layout.fillWidth: true

                SettingsBar {
                    id: settingsBar

                    anchors.horizontalCenter: parent.horizontalCenter
                    onThemeChanged: {
                        if (checked) {
                            root.Universal.theme = Universal.Dark
                        } else {
                            root.Universal.theme = Universal.Light
                        }
                        controller.changeTheme(checked);
                    }
                }
            }

            GroupBox {
                title: qsTr("Go to slot:")
                Layout.preferredWidth: 0.45 * contentPlaceholder.width
                Layout.fillHeight: true

                SlotConnector {
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: telnetSender.connected
                }
            }

            GroupBox {
                title: qsTr("Time skew:")
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 0.4 * contentPlaceholder.width
                Layout.maximumWidth: 0.4 * contentPlaceholder.width

                TimeSkewSelector {
                    anchors.centerIn: parent
                    enabled: telnetSender.connected
                }
            }

            GroupBox {
                title: qsTr("Quick command:")
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: contentPlaceholder.width
                Layout.columnSpan: 3

                QuickCommand {
                    anchors.fill: parent
                    enabled: telnetSender.connected
                }
            }
        }

        GroupBox {
            title: qsTr("Commands:")

            anchors {
                top: gridLayout.bottom
                left: contentPlaceholder.left
                right: contentPlaceholder.right
                bottom: contentPlaceholder.bottom
                margins: 10
            }

            Item {
                id: buttonsPlaceholder

                anchors.fill: parent

                ScrollView {
                    id: commandsScrollView

                    anchors.fill: parent

                    clip: true

                    Grid {
                        id: grid

                        spacing: 10

                        Repeater {
                            id: repeater

                            anchors.fill: parent

                            model: controller.buttonModel

                            delegate: MaterialButton {
                                onLeftClicked: telnetSender.send(buttonArgs)
                                onRightClicked: contextMenu.popup()
                                onPressAndHold: contextMenu.popup()

                                Menu {
                                    id: contextMenu

                                    MenuItem {
                                        text: qsTr("Edit")
                                        onTriggered: popup.openEdit(index, buttonName, buttonArgs)
                                    }

                                    MenuItem {
                                        text: qsTr("Remove")
                                        onTriggered: controller.buttonModel.removeButton(index)
                                    }
                                }
                            }
                        }
                    }
                }

                Button {
                    text: qsTr("Add command")

                    anchors {
                        right: commandsScrollView.right
                        rightMargin: 20
                    }

                    width: 120
                    height: 40

                    onClicked: popup.open()
                }
            }
        }

        ButtonEditPopup {
            id: popup
        }

        NyanCat {
            id: cat
            anchors.bottom: contentPlaceholder.bottom
        }
    }

    onClosing: {
        controller.saveCurrentConfig()
    }
}
