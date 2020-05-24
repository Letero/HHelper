import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Material 2.2

Rectangle {
    width: 120
    height: 40

    color: mouseArea.pressed ? Universal.baseMediumLowColor : Universal.accent

    border.width: mouseArea.containsMouse ? 2 : 0
    border.color: Universal.baseMediumColor

    signal leftClicked()
    signal rightClicked()
    signal pressAndHold()

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
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                leftClicked()
            }

            if (mouse.button === Qt.RightButton){
                rightClicked()
            }
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized)
                pressAndHold()
        }
    }
}
