import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

import "../controls"

Column {
    id: root

    spacing: 10

    ComboBox {
        id: languageCombo

        width: 200

        textRole: "key"
        valueRole: "value"

        onActivated: {
            telnetSender.send(['lang ' + currentValue])
        }

        delegate: ItemDelegate {
            height: 30
            width: parent.width
            contentItem: Rectangle {
                anchors.fill: parent
                border {
                    color: Universal.accent
                    width: 2
                }
                color: parent.hovered ? "grey"
                                      : languageCombo.currentIndex == index
                                        ? Universal.accent : Universal.background

                MaterialText {
                    anchors.centerIn: parent
                    text: key
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        model: ListModel {
            ListElement { key: "English (US)"; value: "en" }
            ListElement { key: "English (GB)"; value: "en" }
            ListElement { key: "Spanish";      value: "es" }
            ListElement { key: "German";       value: "de" }
            ListElement { key: "Russian";      value: "ru" }
            ListElement { key: "Polish";       value: "pl" }
            ListElement { key: "French";       value: "fr" }
            ListElement { key: "Japanese";     value: "ja" }
            ListElement { key: "Chinese";      value: "zh" }
            ListElement { key: "Taiwanese";    value: "zh-TW" }
            ListElement { key: "Italian";      value: "it" }
            ListElement { key: "Es-America";   value: "es-419" }
            ListElement { key: "Dutch";        value: "nl" }
            ListElement { key: "Norwegian";    value: "no" }
            ListElement { key: "Turkish";      value: "tr" }
            ListElement { key: "Korean";       value: "ko" }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: telnetSender.connected

        spacing: 10

        TextField {
            id: customLanguage

            width: 50
            height: languageSetButton.height
            selectByMouse: true
            font.pointSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.QtRendering
            onAccepted: languageSetButton.onClicked()
        }

        Button {
            id: languageSetButton

            width: languageCombo.width - customLanguage.width - parent.spacing

            text: qsTr("Set")

            property int clickCounter: 0

            Timer {
                id: clickTimer
                running: false
                interval: 100

                onTriggered: parent.clickCounter = 0
            }

            function evaluateCat() {
                clickTimer.start()
                ++clickCounter
                if (clickCounter === 3) {
                    clickCounter = 0
                    cat.start()
                }
            }

            onClicked: {
                telnetSender.send(['lang ' + customLanguage.text])

                evaluateCat()
            }
        }
    }
}
