import QtQuick 2.0
import QtQuick.Controls 2.14

Button {
    id: control

    width: 42
    height: width
    hoverEnabled: true

    property string image
    property string imagePressed

    background: Rectangle {
        color: "transparent"
        border.width: parent.hovered ? 2 : 1
        border.color: "black"
    }

    Image {
        id: pin

        anchors.centerIn: parent
        source: imagePressed
                    ? parent.checked || parent.pressed ? imagePressed : image
                    : image
    }
}
