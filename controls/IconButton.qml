import QtQuick 2.0
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
import QtQuick.Controls.Universal 2.12

Button {
    id: control

    width: 42
    height: width
    hoverEnabled: true

    property string tooltipText: ""
    property string image
    property string imagePressed
//    property alias sca: value

    ToolTip.delay: 800
    ToolTip.visible: hovered && tooltipText
    ToolTip.text: tooltipText

    background: Rectangle {
        color: "transparent"
        border.width: parent.hovered ? 2 : 1
        border.color: Universal.foreground
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
            color: Universal.foreground
        }
    }
