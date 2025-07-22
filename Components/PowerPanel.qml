import QtQuick
import QtQuick.Controls

Item {
    Button {
        id: powerButton
        height: 50
        width: 50
        hoverEnabled: true

        Text {
            color: "white"
            font.family:  Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
            text: String.fromCodePoint(0xe7e8)
            renderType: Text.NativeRendering
            font.pointSize: powerButton.height / 2
            anchors.centerIn: powerButton
        }

        ToolTip {
            id: powerButtonTip

            delay: 1000
            timeout: 4800
            leftPadding: 9
            rightPadding: 9
            topPadding: 7
            bottomPadding: 7
            y: powerButton.height + 5
            z: 2
            visible: powerButton.hovered

            contentItem: Text {
                text: "Power"
                font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                renderType: Text.NativeRendering
                color: "white"
            }

            background: Rectangle {
                color: "#2A2A2A"
                border.width: 1
                border.color: "#1A1A1A"
            }
        }

        background: Rectangle {
            id: powerButtonBackground
            color: "transparent"
        }

        states: [
            State {
                name: "pressed"
                when: powerButton.down
                PropertyChanges {
                    target: powerButtonBackground
                    color: "#33FFFFFF"
                }
            },

            State {
                name: "hovered"
                when: powerButton.hovered
                PropertyChanges {
                    target: powerButtonBackground
                    color: "#1AFFFFFF"
                }
            },

            State {
                name: "selection"
                when: powerPopup.visible
                PropertyChanges {
                    target: powerButtonBackground
                    color: "transparent"
                }
            }
        ]

        onClicked: {
            powerPopup.visible ? powerPopup.close() : powerPopup.open()
            powerPopup.visible === powerPopup.open ; powerButton.state = "selection"
            powerButtonTip.hide()
        }
    }

    Popup {
        id: powerPopup
        width: 125
        height: poweroffButton.height + rebootButton.height + sleepButton.height + 10
        x: Math.round((powerButton.width - width) / 2) - 13
        y: -117
        z: 3
        topPadding: 5
        bottomPadding: 5
        leftPadding: 1
        rightPadding: 1
        background: Rectangle {
            color: "#F51F1F1F"
            border.width: 1
            border.color: "black"
        }

        Button {
            id: poweroffButton
            width: parent.width
            height: 34
            hoverEnabled: true

            ToolTip {
                id: poweroffTip

                delay: 1000
                timeout: 4800
                leftPadding: 9
                rightPadding: 9
                topPadding: 7
                bottomPadding: 7
                visible: poweroffButton.hovered

                contentItem: Text {
                    text: "Closes all apps and turns off the PC."
                    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                    renderType: Text.NativeRendering
                    color: "white"
                }

                background: Rectangle {
                    color: "#2A2A2A"
                    border.width: 1
                    border.color: "#1A1A1A"
                }
            }

            background: Rectangle {
                id: poweroffButtonBackground
                color: "transparent"
                border.width: 0
                border.color: "#29292A"
            }

            Text {
                text: "Shut Down"
                color: "white"

                font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                font.pointSize: 10
                leftPadding: 10
                renderType: Text.NativeRendering

                anchors {
                    left: poweroffIcon.right
                    verticalCenter: poweroffButton.verticalCenter
                }
            }

            Text {
                id: poweroffIcon
                color: "white"
                font.family:  Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
                text: String.fromCodePoint(0xe7e8)
                renderType: Text.NativeRendering
                font.pointSize: 12

                x: 10

                anchors {
                    verticalCenter: poweroffButton.verticalCenter
                }
            }


            states: [
                State {
                    name: "hovered"
                    when: poweroffButton.hovered
                    PropertyChanges {
                        target: poweroffButtonBackground
                        color: "#30FFFFFF"
                        border.color: "#60FFFFFF"
                        border.width: 1
                    }
                }
            ]

            onClicked: sddm.powerOff()
        }

        Button {
            id: rebootButton
            width: parent.width
            height: 34
            hoverEnabled: true

            anchors {
                horizontalCenter: poweroffButton.horizontalCenter
                top: poweroffButton.bottom
            }

            background: Rectangle {
                id: rebootButtonBackground
                color: "transparent"
                border.width: 0
                border.color: "#29292A"
            }

            Text {
                id: rebootText
                text: "Restart"
                color: "white"

                font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                font.pointSize: 10
                leftPadding: 10
                renderType: Text.NativeRendering

                anchors {
                    left: rebootIcon.right
                    verticalCenter: rebootButton.verticalCenter
                }
            }

            Text {
                id: rebootIcon
                color: "white"
                font.family:  Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
                text: String.fromCodePoint(0xe777)
                renderType: Text.NativeRendering
                font.pointSize: 12

                x: 10

                anchors {
                    verticalCenter: rebootButton.verticalCenter
                }
            }

            ToolTip {
                id: rebootButtonTip

                delay: 1000
                timeout: 4800
                leftPadding: 9
                rightPadding: 9
                topPadding: 7
                bottomPadding: 7
                visible: rebootButton.hovered

                contentItem: Text {
                    text: "Closes all apps, turns off the PC, and then turns it on
again."             // I had to make it like this, so it's normal, don't touch.
                    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                    renderType: Text.NativeRendering
                    color: "white"
                }

                background: Rectangle {
                    color: "#2A2A2A"
                    border.width: 1
                    border.color: "#1A1A1A"
                }
            }

            states: [
                State {
                name: "hovered"
                when: rebootButton.hovered
                    PropertyChanges {
                        target: rebootButtonBackground
                        color: "#30FFFFFF"
                        border.color: "#60FFFFFF"
                        border.width: 1
                    }
                }
            ]

            onClicked: sddm.reboot()
        }

        Button {
            id: sleepButton
            width: parent.width
            height: 34
            hoverEnabled: true

            anchors {
                horizontalCenter: rebootButton.horizontalCenter
                top: rebootButton.bottom
            }

            background: Rectangle {
                id: sleepButtonBackground
                color: "transparent"
                border.width: 0
                border.color: "#29292A"
            }

            Text {
                text: "Sleep"
                color: "white"

                font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                font.pointSize: 10
                leftPadding: 10
                renderType: Text.NativeRendering

                anchors {
                    left: sleepIcon.right
                    verticalCenter: sleepButton.verticalCenter
                }
            }

            Text {
                id: sleepIcon
                color: "white"
                font.family: Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
                text: String.fromCodePoint(0xe708)
                renderType: Text.NativeRendering
                font.pointSize: 12

                x: 10

                anchors {
                    verticalCenter: sleepButton.verticalCenter
                }
            }

            ToolTip {
                id: sleepButtonTip

                delay: 1000
                timeout: 4800
                leftPadding: 9
                rightPadding: 9
                topPadding: 7
                bottomPadding: 7
                visible: sleepButton.hovered

                contentItem: Text {
                    text: "The PC stays on but uses low power. Apps stay open so
when the PC wakes up, you're instantly back to where
you left off."      // Again, it had to be like this, don't touch.
                    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                    renderType: Text.NativeRendering
                    color: "white"
                }

                background: Rectangle {
                    color: "#2A2A2A"
                    border.width: 1
                    border.color: "#1A1A1A"
                }
            }

            states: [
                State {
                name: "hovered"
                when: sleepButton.hovered
                    PropertyChanges {
                        target: sleepButtonBackground
                        color: "#30FFFFFF"
                        border.color: "#60FFFFFF"
                        border.width: 1
                    }
                }
            ]

            onClicked: sddm.suspend()
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                easing.type: Easing.OutCirc
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                easing.type: Easing.OutCirc
            }
        }
    }
}
