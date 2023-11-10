import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Material 2.2

Rectangle {
    width: 120
    height: 40

    property alias text: textItem.text
    property alias tooltip: tooltipItem.text

    property bool spacePressed: false

    color: spacePressed || mouseArea.pressed ? Universal.baseMediumLowColor : Universal.accent

    border.width: mouseArea.containsMouse ? 2 : 0
    border.color: Universal.baseMediumColor

    signal leftClicked()
    signal rightClicked()
    signal pressAndHold()

    MaterialText {
        id: textItem

        anchors.fill:parent
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
        acceptedButtons: Qt.AllButtons
        onPressed: parent.forceActiveFocus()
        onClicked: function( mouse ) {
            if (mouse.button === Qt.LeftButton) {
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

    ToolTip {
        id: tooltipItem

        y: parent.height + 4

        delay: 400

        visible: mouseArea.containsMouse
    }

    Keys.onReleased: if (event.key === Qt.Key_Space) spacePressed = false

    Keys.onSpacePressed: {
        spacePressed = true
        leftClicked()
    }
}
