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

            width: 0.4 * slider.width
            height: 40
            selectByMouse: true
            font.pointSize: 9
            maximumLength: 6
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.QtRendering
            onTextChanged: {
                var value = parseFloat(text)
                if (value >= slider.from)
                {
                    var fixed = value < 0.1 ? 4 : 1
                    slider.value = parseFloat(text).toFixed(fixed)
                }
                else if(value > 0)
                {
                    text = slider.from
                    slider.value = slider.from
                }
            }

            onActiveFocusChanged: {
                if (!activeFocus)
                {
                    if (text == "")
                    {
                        slider.onValueChanged()
                        return
                    }

                    var value = parseFloat(text)
                    if (value < slider.from)
                    {
                        text = slider.from
                    }
                    else
                    {
                        var fixed = value < 0.1 ? 4 : 1
                        text = value.toFixed(fixed)
                    }

                }
            }
        }

        Slider {
            id: slider

            height: 45
            width: 140
            snapMode: "SnapAlways"
            from: 0.0001
            to: 5
            stepSize: 0.1
            value: 1.0

            onValueChanged: {
                var fixed = value < 0.1 ? 4 : 1
                telnetSender.send(["9 " + value.toFixed(fixed)])
                var fixedValue = value.toFixed(fixed)
                if (fixedValue !== parseFloat(sliderValue.text).toFixed(fixed))
                {
                    sliderValue.text = fixedValue
                }
            }

            Component.onCompleted: {
                sliderValue.text = value.toFixed(1)
            }
        }

        Button {
            text: "Reset"
            width: 0.5 * slider.width
            height: 40

            onClicked: {
                slider.value = parseFloat(1)
                telnetSender.send(["9 1"])
            }
        }
    }
}
