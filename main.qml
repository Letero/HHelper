import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import com.company.TelnetSender 1.0
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

    TelnetSender{
        id: telnetSender

        host: hostAddress.text
    }

    Controller {
        id: controller
    }

    Component.onCompleted: {
        themeSwitch.checked = controller.isDarkTheme()
        telnetSender.connectToTelnet()
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
                    text: qsTr("Host (address):")
                    font.pointSize: 12
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5
                    TextField {
                        id: hostAddress

                        width: slotSelector.width - saveHostButton.width - parent.spacing
                        height: 45
                        selectByMouse: true
                        font.pointSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        placeholderText: "localhost"
                        renderType: Text.QtRendering
                        text: controller.getHost()
                        onTextChanged: controller.setHost(text)
                    }
                    Button {
                        id: saveHostButton

                        anchors.verticalCenter: parent.verticalCenter
                        width: 60
                        height: hostAddress.height
                        text: qsTr("Save")
                        font.pixelSize: 14
                        onClicked: {
                            saveHostPopup.open()
                        }


                        SaveHostPopup {
                            id: saveHostPopup

                            addressText: hostAddress.text

                            onSaveClicked: {
                                controller.hostModel.addHost(addressText, nameText)
                            }
                            onOpened: nameText = ""
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: 5

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: hostAddress.width
                        font.pointSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        text: telnetSender.connected ? qsTr("Connected") : qsTr("Not connected")
                        color: telnetSender.connected ? "green" : "red"
                    }

                    Button {
                        anchors.verticalCenter: parent.verticalCenter
                        width: saveHostButton.width
                        height: saveHostButton.height
                        text: qsTr("Retry")
                        font.pixelSize: 14
                        onClicked: {
                            telnetSender.connectToTelnet()
                        }
                    }
                }

                ComboBox {
                    id: hostCombo

                    width: 240
                    model: controller.hostModel
                    displayText: "Choose saved"
                    valueRole: "address"
                    popup.width: 400

                    onActivated: {
                        hostAddress.text = currentValue
                        index = -1
                    }

                    delegate: ItemDelegate {
                        id: itemDelegate

                        height: 40
                        width: parent.width
                        contentItem: Rectangle {
                            anchors.fill: parent
                            border {
                                color: Universal.accent
                                width: 2
                            }

                            color: parent.hovered ? "gray" : Universal.background

                            MaterialText {
                                anchors {
                                    left: parent.left
                                    leftMargin: 10
                                    verticalCenter: parent.verticalCenter
                                }
                                font.pointSize: 12
                                text: name + " (" + address + ")"
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }

                            Button {
                                id: removeButton

                                anchors {
                                    right: parent.right
                                    rightMargin: 8
                                    verticalCenter: parent.verticalCenter
                                }
                                text: qsTr("Remove")
                                onClicked: {
                                    controller.hostModel.removeHost(index)
                                }
                            }

                            Button {
                                id: editButton

                                anchors {
                                    right: removeButton.left
                                    rightMargin: 8
                                    verticalCenter: parent.verticalCenter
                                }
                                text: qsTr("Edit")

                                onClicked: editHostPopup.open()

                                SaveHostPopup {
                                    id: editHostPopup

                                    addressText: address
                                    nameText: name

                                    onSaveClicked: {
                                        controller.hostModel.editHost(index, addressText, nameText)
                                    }
                                }
                            }
                        }
                    }

                }

                Row {
                    enabled: telnetSender.connected

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

                    enabled: telnetSender.connected

                    spacing: 10

                    Button {
                        id: goSlotButton

                        width: 80
                        height: 40
                        text: qsTr("Go to slot:")
                        font.pixelSize: 14

                        property string slotType: ""

                        onClicked: {
                            var commands = []
                            var slotId = controller.validateSlotName(slotName.text)
                            commands = ['launchGame ' + slotId + slotType]
                            telnetSender.send(commands)
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
                        text: controller.getSlotName() != "" ? controller.getSlotName() : "Slots"
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

                enabled: telnetSender.connected

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

                    onValueChanged: {
                        console.log(value.toFixed(1))
                        telnetSender.send(['9 ' + value.toFixed(1)])
                    }
                }

                Row {
                    id: timeskewRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    TextField {
                        id: sliderValue

                        width: slider.width
                        height: 40
                        selectByMouse: true
                        font.pointSize: 9
                        horizontalAlignment: Text.AlignHCenter
                        text: slider.value.toFixed(1)
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.QtRendering
                        onTextChanged: {
                            slider.value = parseFloat(text)
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Reset"
                    width: slider.width
                    height: 40

                    onClicked: {
                        slider.value = parseFloat(1)
                        timeskewRow.setTimeskew()
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
                    enabled: telnetSender.connected

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

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: telnetSender.connected

                    spacing: 20

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

                        width: 100

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

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    MaterialText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Dark theme"
                        font.pixelSize: 14
                        verticalAlignment: Qt.AlignVCenter
                    }

                    Switch {
                        id: themeSwitch

                        anchors.verticalCenter: parent.verticalCenter
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

            enabled: telnetSender.connected

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
                                    telnetSender.send(buttonArgs)
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

        NyanCat {
            id: cat
            anchors.bottom: contentPlaceholder.bottom
        }
    }
}
