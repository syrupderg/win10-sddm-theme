import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: container

    property alias name: name.text
    property alias icon: icon.source

    height: 58
    color: "transparent"

    anchors.left: parent.left

    MouseArea {
        id: rectArea
        hoverEnabled: true
        anchors.fill: parent

        onEntered: {
            if (container.focus == false)
            container.color = "#30FFFFFF";
        }

        onExited: {
            if (container.focus == false)
            container.color = "transparent";
        }
    }

    states: [
        State {
            name: "focused"
            when: container.focus
            PropertyChanges {
                target: container
                color: config.color
            }
        },
        State {
            name: "unfocused"
            when: !container.focus
            PropertyChanges {
                target: container
                color: "transparent"
            }
        }
    ]

    Item {
        id: users

        Image {
            id: icon
            width: 48
            height: 48
            smooth: true
            visible: false

            onStatusChanged: {
                if (icon.status == Image.Error)
                    icon.source = "../user-192.png"
                else
                    "/var/lib/AccountsService/icons/" + name
            }

            x: 12
            y: 5
        }

        MultiEffect {
            anchors.fill: icon
            source: icon
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Item {
            id: mask
            width: icon.width
            height: icon.height
            layer.enabled: true
            layer.smooth: true
            visible: false

            Rectangle {
                width: icon.width
                height: icon.height
                radius: width / 2
                color: "black"
            }
        }

        Text {
            id: name
            renderType: Text.NativeRendering
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
            font.pointSize: 10
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            clip: true

            color: "white"

            anchors {
                verticalCenter: icon.verticalCenter
                left: icon.right
                leftMargin: 12
            }
        }
    }
}
