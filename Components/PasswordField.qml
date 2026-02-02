import QtQuick
import QtQuick.Controls

TextField {
    id: passwordField
    focus: true
    visible: true
    selectByMouse: true
    placeholderText: "Password"

    // no idea why i added this before but keeping it just to be safe
    // property alias text: passwordField.text

    echoMode: TextInput.Password ? TextInput.Password : TextInput.Normal
    selectionColor: config.color

    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
    font.pointSize: 10.9
    renderType: Text.NativeRendering

    color: "black"

    x: 3

    horizontalAlignment: TextInput.AlignLeft
    width: 258
    height: 32

    background: Rectangle {
        id: passFieldBackground
        color: "white"
        x: -3
        width: parent.width
        height: parent.height
    }
}
