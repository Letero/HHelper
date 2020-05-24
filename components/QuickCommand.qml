import QtQuick 2.0
import QtQuick.Controls 2.12

Row {
    spacing: 10

    TextField {
        id: quickCommand
        width: 200
        height: 35
        selectByMouse: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 11
        renderType: Text.QtRendering
        onAccepted: sendQuickCommandButton.onClicked()
    }
    Button {
        id: sendQuickCommandButton
        text: "Send"
        onClicked: telnetSender.send(quickCommand.text)
    }
}
