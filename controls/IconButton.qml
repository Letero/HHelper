import QtQuick 2.0
import QtQuick.Controls 2.14
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.Universal 2.12

Button {
    id: control

    width: 42
    height: width
    hoverEnabled: true

    property string tooltipText: ""
    property string image
    property string imagePressed

    ToolTip.delay: 800
    ToolTip.visible: hovered && tooltipText
    ToolTip.text: tooltipText

    background: Rectangle {
        color: "transparent"
        border.width: parent.hovered ? 2 : 1
        border.color: control.enabled ? Universal.foreground : "gray"
    }

    Image {
        id: pic

        anchors.centerIn: parent
        source: imagePressed
                    ? parent.checked || parent.pressed ? imagePressed : image
                    : image
    }

        ColorOverlay {
            anchors.fill: pic
            source: pic
            color: control.enabled ? Universal.foreground : "gray"
        }
    }
