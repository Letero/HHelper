import QtQuick 2.0
import com.company.jsonparser 1.0



JsonParser {
    id: jsonparser
    function getTargetName() {
        return jsonparser.getTargetWindowName()
    }
    function setTargetName(targetWindowName) {
        jsonparser.setTargetWindowName(targetWindowName)
    }
}

