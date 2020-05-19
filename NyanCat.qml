import QtQuick 2.0

AnimatedImage {
    id: cat

    source: "res/nyan.gif"
    visible: false

    height: 120
    width: 120

    function start() {
        if (!catTimer.running) {
            x = -width
            cat.visible = true
            catTimer.start()
        }
    }

    function stop() {
        cat.visible = false
        catTimer.stop()
    }

    Timer {
        id: catTimer

        interval: 50
        running: false
        repeat: true

        onTriggered: {
            parent.x += 5
            if (parent.x > root.width + cat.width) cat.stop()
        }
    }
}
