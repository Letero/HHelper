import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import com.company.keystrokessender 1.0
import com.company.controller 1.0
import Colors 1.0
import QtQuick.Window 2.2
import QtQuick.Controls.Universal 2.12

Window {
    id: root

    width: 720
    minimumWidth: 720
    maximumWidth: 720
    height: 540

    flags: pinButton.checked ? (Qt.Window | Qt.WindowStaysOnTopHint) : Qt.Window

    visible: true
    title: qsTr("HHelper")

    color: Universal.background
    Universal.theme: Universal.Light

    Universal.accent: Universal.theme == Universal.Light ? "#f2a365" : "#30475e"
    Universal.foreground: Universal.theme == Universal.Light ? "#222831" : "#ececec"
    Universal.background: Universal.theme == Universal.Light ? "#ececec" : "#222831"

    KeystrokesSender{
        id: keysender
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        keysender.setupTargetWindow(targetWindow.text)
        modeSelector.checked = controller.isDevMode()
        themeSwitch.checked = controller.isDarkTheme()
    }

    Item {
        id: contentPlaceholder

        y: 5
        height: root.height - y
        width: root.width

        Row {
            id: row

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: pinButton.checked ? 21 : 20
                topMargin: pinButton.checked ? 24 : 0
            }

            spacing: 10

            Column {
                id: slotSection

                spacing: 10

                MaterialText {
                    text: qsTr("Target window:")
                    font.pointSize: 12
                }

                TextField {
                    id: targetWindow

                    width: slotSelector.width
                    height: 45
                    selectByMouse: true
                    font.pointSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: controller.getTargetWindow()
                    renderType: Text.QtRendering
                    onTextChanged: {
                        keysender.setupTargetWindow(text)
                        controller.setTargetWindow(text)
                    }
                }

                Row {
                    RadioButton {
                        text: "Default"
                        checked: true
                        onCheckedChanged: if (checked) goSlotButton.slotType = ""

                    }
                    RadioButton {
                        text: "HL"
                        onCheckedChanged: if (checked) goSlotButton.slotType = "HighLimit"
                    }
                    RadioButton {
                        text: "HR"
                        onCheckedChanged: if (checked) goSlotButton.slotType = "HighRoller"
                    }
                }

                Row {
                    id: slotSelector

                    spacing: 10

                    Button {
                        id: goSlotButton

                        width: 80
                        height: 40
                        text: qsTr("Go to slot:")
                        font.pixelSize: 14

                        property var gotoSlot: []
                        property string slotType: ""

                        onClicked: {
                            var slotId = controller.validateSlotName(slotName.text)
                            gotoSlot = ['launchGame ' + slotId + slotType]
                            keysender.sendKeystroke(gotoSlot)
                        }
                    }

                    TextField {
                        id: slotName
                        width: 150
                        height: 40
                        selectByMouse: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 11
                        text: controller.getSlotName()
                        renderType: Text.QtRendering
                        onTextChanged: {
                            controller.setSlotName(text)
                        }
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                spacing: 10

                MaterialText {
                    text: qsTr("Timeskew:")
                    font.pointSize: 12
                }

                Slider {
                    id: slider

                    height: 45
                    width: 140
                    snapMode: "SnapAlways"
                    from: 0.1
                    to: 5
                    stepSize: 0.1
                    value: 1.0
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 10

                    TextField {
                        id: sliderValue

                        width: 60
                        height: 40
                        selectByMouse: true
                        font.pointSize: 9
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: slider.value.toFixed(1)
                        renderType: Text.QtRendering
                        onTextChanged: {
                            slider.value = parseFloat(text)
                        }
                    }

                    Button {
                        text: "Set"
                        width: 60
                        height: 40

                        property var timeskew: []

                        onClicked: {
                            timeskew = ['9 ' + slider.value.toFixed(1)]
                            keysender.sendKeystroke(timeskew)
                        }
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                spacing: 10

                MaterialText {
                    text: qsTr("Language:")
                    font.pointSize: 12
                }

                ComboBox {
                    id: languageCombo

                    width: 100

                    textRole: "key"
                    valueRole: "value"

                    delegate: ItemDelegate {
                           height: 30
                           width: parent.width
                           contentItem: Rectangle {
                               anchors.fill: parent
                               color: parent.hovered ? "lightgrey"
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
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 100

                    text: qsTr("Set")

                    property var temp: []
                    onClicked: {
                        temp = ['lang ' + languageCombo.currentValue]
                        keysender.sendKeystroke(temp)
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter

                MaterialText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Dev mode"
                    font.pixelSize: 14
                    verticalAlignment: Qt.AlignVCenter
                }

                Switch {
                    id: modeSelector

                    anchors.horizontalCenter: parent.horizontalCenter

                    height: 40

                    onCheckedChanged: {
                        keysender.devMode = checked;
                        controller.changeDevMode(checked);
                    }
                }

                MaterialText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Dark theme"
                    font.pixelSize: 14
                    verticalAlignment: Qt.AlignVCenter
                }

                Switch {
                    id: themeSwitch

                    anchors.horizontalCenter: parent.horizontalCenter

                    height: 40

                    onCheckedChanged: {
                        if (checked) {
                            root.Universal.theme = Universal.Dark
                        } else {
                            root.Universal.theme = Universal.Light
                        }
                        controller.changeTheme(checked);
                    }
                }
            }

            Rectangle {
                width: 1
                height: parent.height
                color: "lightgrey"
            }

            Column {
                spacing: 10

                IconButton {
                    id: pinButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    checkable: true
                    image: "res/pin-outline.png"
                    imagePressed: "res/pin.png"

                    tooltipText: qsTr("Pin application to stay always on top.")
                }

                IconButton {
                    id: saveConfigButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    image: "res/content-save-cog-outline.png"
                    imagePressed: "res/content-save-cog.png"

                    tooltipText: qsTr("Save changes to config file.")

                    onClicked: controller.saveCurrentConfig()
                }

                IconButton {
                    id: closeButton

                    anchors.horizontalCenter: parent.horizontalCenter

                    visible: pinButton.checked
                    image: "res/close.png"

                    tooltipText: qsTr("Close application.")

                    onClicked: Qt.quit()
                }
            }
        }

        Rectangle {
            height: 1
            width: contentPlaceholder.width - 60
            anchors {
                bottom: buttonsPlaceholder.top
                horizontalCenter: contentPlaceholder.horizontalCenter
                bottomMargin: 15
            }

            color: "lightgrey"
        }

        Row {
            id: buttonsPlaceholder

            anchors {
                top: row.bottom
                left: contentPlaceholder.left
                right: contentPlaceholder.right
                bottom: contentPlaceholder.bottom
                leftMargin: 30
                topMargin: 40
            }

            spacing: 10

            Grid {
                id: grid

                spacing: 10

                Repeater {
                    id: repeater

                    anchors.fill: parent

                    model: controller.buttonModel

                    delegate: Rectangle {
                        id: test

                        width: 120
                        height: 40

                        color: mouseArea.pressed ? Colors.mist : Universal.accent

                        MaterialText {
                            anchors.fill:parent
                            text: buttonName
                            font.pointSize: 9
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.margins: {
                                left: 10
                                right: 10
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: {
                                if (mouse.button == Qt.LeftButton) {
                                    keysender.sendKeystroke(buttonArgs)
                                }

                                if (mouse.button === Qt.RightButton){
                                    contextMenu.popup()
                                }
                            }
                            onPressAndHold: {
                                if (mouse.source === Qt.MouseEventNotSynthesized)
                                    contextMenu.popup()
                            }
                        }
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

            Button {
                text: qsTr("Add button")

                width: 120
                height: 40

                contentItem: MaterialText {
                    text: parent.text
                    color: Universal.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }

                onClicked: popup.open()
            }
        }

        ButtonEditPopup {
            id: popup
        }
    }
}
