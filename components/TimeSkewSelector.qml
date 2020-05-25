import QtQuick 2.0
import QtQuick.Controls 2.12

import "../controls"

Column {
    spacing: 10

    Row {
        id: timeskewRow

        spacing: 5

        TextField {
            id: sliderValue

            width: 0.3 * slider.width
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
                telnetSender.send(['9 ' + value.toFixed(1)])
            }
        }

        Button {
            text: "Reset"
            width: 0.5 * slider.width
            height: 40

            onClicked: {
                slider.value = parseFloat(1)
                timeskewRow.setTimeskew()
            }
        }
    }
}
