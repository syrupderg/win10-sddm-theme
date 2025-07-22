import QtQuick
import QtQuick.Controls

Rectangle {
    id: capsButton

    color: "transparent"

    x: -50

    Text {
        color: "white"
        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
        text: "Caps Lock is on"
        renderType: Text.NativeRendering
        font.weight: Font.Bold
        font.pointSize: 12
    }
}


