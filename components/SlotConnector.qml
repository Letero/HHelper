import QtQuick 2.0
import QtQuick.Controls 2.12

Column {
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

        enabled: telnetSender.connected

        spacing: 10

        Button {
            id: goSlotButton

            width: 80
            height: 35
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
            height: 35
            selectByMouse: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 11
            text: controller.getSlotName() !== "" ? controller.getSlotName() : "Slots"
            renderType: Text.QtRendering
            onTextChanged: {
                controller.setSlotName(text)
            }
        }
    }
}
