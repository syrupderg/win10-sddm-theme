import QtQuick
import QtQuick.Controls

Button {
    id: loginButton
    hoverEnabled: true
    width: 31
    height: 32
    x: passwordField.width

    Text {
    color: "white"
    text: String.fromCodePoint(0xebe7)
    font.family:  Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
    font.pointSize: 13
    renderType: Text.NativeRendering
    anchors.centerIn: parent
    }

    background: Rectangle {
        id: loginbuttonBackground
        color: "#35FFFFFF"
    }

    states: [
       State {
            name: "pressed"
            when: loginButton.down
            PropertyChanges {
                target: loginbuttonBackground
                color: "#75FFFFFF"
            }
        }
    ]
}
