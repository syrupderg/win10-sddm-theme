import QtQuick
import QtQuick.Controls

TextField {
    id: passwordFieldPin
    focus: true
    visible: true
    selectByMouse: true
    placeholderText: "PIN"

    // no idea why i added this before but keeping it just to be safe
    // property alias text: passwordFieldPin.text

    echoMode: TextInput.Password ? TextInput.Password : TextInput.Normal
    selectionColor: config.color

    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
    font.pointSize: 10.9
    renderType: Text.NativeRendering

    color: "black"

    x: 3

    horizontalAlignment: TextInput.AlignLeft
    width: 289
    height: 32

    background: Rectangle {
        id: passFieldBackgroundPin
        color: "white"
        x: -3
        width: parent.width
        height: parent.height
    }
}
