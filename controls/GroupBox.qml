import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

GroupBox {
    id: control

    focusPolicy: Qt.StrongFocus

    background: Rectangle {
        y: control.topPadding - control.padding
        width: parent.width
        height: parent.height - control.topPadding + control.padding
        color: Universal.background
        border.color: "grey"
        radius: 2
    }

    label: Rectangle {
        anchors {
            left: parent.left
            leftMargin: 10
            bottom: parent.top
            bottomMargin: -height / 2
        }

        color: Universal.background
        width: 1.1 * title.contentWidth
        height: title.font.pixelSize

        MaterialText {
            id: title
            text: control.title
            anchors.centerIn: parent
            font.pixelSize: 16
        }
    }
}
