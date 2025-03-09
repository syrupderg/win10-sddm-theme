import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects
import "Components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    FontLoader {
        id: segoeui
        source: Qt.resolvedUrl("fonts/segoeui.ttf")
    }

    FontLoader {
        id: segoeuil
        source: Qt.resolvedUrl("fonts/segoeuil.ttf")
    }

    FontLoader {
        id: iconfont
        source: Qt.resolvedUrl("fonts/SegMDL2.ttf")
    }

    Rectangle {
        id: background
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "transparent"

        z: 1

        Image {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: config.background

            Rectangle {
                width: parent.width
                height: parent.height
                color: "blue"
            }
        }
    }

    Rectangle {
        id: startupBg
        width: Screen.width
        height: Screen.height
        color: "transparent"
        z: 4

        Image {
            anchors.fill: parent
            width: Screen.width
            height: Screen.height
            smooth: true
            source: config.background

            Rectangle {
                id: backRect
                width: Screen.width
                height: Screen.height
                color: "#15000000"
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: timeDate
            drag.axis: Drag.YAxis
            drag.minimumY: -Screen.height / 2
            drag.maximumY: 0
            focus: true

            onClicked: {
                listView.focus = true
                mouseArea.focus = false
                mouseArea.enabled = false
                seqStart.start()
                parStart.start()
            }

            Keys.onPressed: {
                listView.focus = true
                mouseArea.focus = false
                mouseArea.enabled = false
                seqStart.start()
                parStart.start()
            }

            property bool dragActive: drag.active

            onDragActiveChanged: {
                if(drag.active) {}
                else {
                    listView.focus = true
                    mouseArea.focus = false
                    mouseArea.enabled = false
                    seqStart.start()
                    parslideStart.start()
                }
            }
        }

        ParallelAnimation {
            id: parStart
            running: false

            NumberAnimation {
                target: timeDate
                properties: "y"
                from: 0
                to: -45
                duration: 125
            }

            NumberAnimation {
                target: timeDate
                properties: "visible"
                from: 1
                to: 0
                duration: 125
            }

            NumberAnimation {
                target: startupBg
                properties: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }

        ParallelAnimation {
            id: parslideStart
            running: false

            NumberAnimation {
                target: startupBg
                properties: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }

        SequentialAnimation {
            id: seqStart
            running: false

            ColorAnimation {
                target: backRect
                properties: "color"
                from: "#15000000"
                to: "#75000000"
                duration: 125
            }

            ParallelAnimation {

                ScaleAnimator {
                    target: background
                    from: 1
                    to: 1.01
                    duration: 250
                }

                NumberAnimation {
                    target: centerPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 225
                }

                NumberAnimation {
                    target: rightPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

                NumberAnimation {
                    target: leftPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }
            }
        }

        Rectangle {
            id: timeDate
            width: parent.width
            height: parent.height
            color: "transparent"

            Column {
                id: timeContainer

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    bottomMargin: 90
                    leftMargin: 35
                }

                property date dateTime: new Date()

                Timer {
                    interval: 100; running: true; repeat: true;
                    onTriggered: timeContainer.dateTime = new Date()
                }

                Text {
                    id: time

                    color: "white"
                    font.pointSize: 95
                    font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuil.name
                    renderType: Text.NativeRendering
                    text: Qt.formatTime(timeContainer.dateTime, "hh:mm")

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        left: parent.left
                    }
                }

                Rectangle {
                    id: spacingRect
                    color: "transparent"
                    width: 15
                    height: 15

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Text {
                    id: date

                    color: "white"
                    font.pointSize: 45
                    font.family: "Segoe UI Light"
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignLeft
                    text: Qt.formatDate(timeContainer.dateTime, "dddd, MMMM dd")

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }



    Item {
        id: centerPanel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: root.width / 1.75
        opacity: 0
        z: 2

        Item {
            Component {
                id: userDelegate

                FocusScope {
                    anchors.centerIn: parent
                    name: (model.realName === "") ? model.name : model.realName
                    icon: "/var/lib/AccountsService/icons/" + model.name

                    property alias icon: icon.source

                    property alias name: name.text

                    property alias password: passwordField.text

                    property alias passwordpin: passwordFieldPin.text

                    property int session: sessionPanel.session

                    width: 296
                    height: 500

                    Connections {
                      target: sddm

                        function onLoginFailed() {
                            truePass.visible = false

                            passwordField.visible = false
                            passwordField.enabled = false
                            passwordField.focus = false

                            rightPanel.visible = false
                            leftPanel.visible = false

                            passwordFieldPin.visible = false
                            passwordFieldPin.enabled = false
                            passwordFieldPin.focus = false

                            falsePass.visible = true
                            falsePass.focus = true
                            bootani.stop()
                        }

                        function onLoginSucceeded() {} //broken, but this time it's not my fault. see https://github.com/sddm/sddm/issues/1960
                    }

                    Rectangle {
                        width: Screen.width
                        height: Screen.height
                        color: "transparent"

                        Image {
                            anchors.fill: parent
                            width: parent.width
                            height: parent.height
                            source: config.background

                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "#75000000"
                            }
                        }

                        x: {
                            if(1680 === Screen.width)
                                -Screen.width / 2 + 28
                            else if(1600 === Screen.width)
                                -Screen.width / 2 + 34
                            else
                                -Screen.width / 2 + 11
                        }

                        // bad idea? yeah but it will work for most of the people. try to come up with something better than this.

                        y: -Screen.height/2
                    }

                    Image {
                        id: icon
                        width: 192
                        height: 192
                        smooth: true
                        visible: false

                        onStatusChanged: {
                            if (icon.status == Image.Error)
                                icon.source = "user-192.png"
                            else
                                "/var/lib/AccountsService/icons/" + name
                        }

                        x: -(icon.width / 2)
                        y: -(icon.width * 2) + (icon.width * 0.8)
                    }

                    OpacityMask {
                        anchors.fill: icon
                        source: icon
                        maskSource: mask
                    }

                    Item {
                        id: mask
                        width: icon.width
                        height: icon.height
                        layer.enabled: true
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
                        color: "white"
                        font.pointSize: 40
                        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuil.name
                        renderType: Text.NativeRendering

                        anchors {
                            topMargin: 15
                            horizontalCenter: icon.horizontalCenter
                            top: icon.bottom
                        }
                    }

                    PasswordField {
                        id: passwordField
                        visible: config.PinMode === "off" ? true : false
                        enabled: config.PinMode === "off" ? true : false
                        focus: config.PinMode === "off" ? true : false
                        x: -135

                        anchors {
                            topMargin: 25
                            top: name.bottom
                        }

                        onTextChanged: {
                            if (passwordField.text !== "") {
                                passwordField.width = 226
                                loginButton.x = passwordField.width + loginButton.width + 1
                                revealButton.x = passwordField.width
                                revealButton.visible = true
                            }

                            else {
                                passwordField.width = 258
                                revealButton.visible = false
                            }
                        }

                        Keys.onReturnPressed: {
                            truePass.visible = true
                            passwordField.visible = false
                            passwordFieldPin.visible = false
                            rightPanel.visible = false
                            leftPanel.visible = false
                            sddm.login(model.name, password, session)

                            bootani.start()
                        }

                        Keys.onEnterPressed: {
                            truePass.visible = true
                            passwordField.visible = false
                            passwordFieldPin.visible = false
                            rightPanel.visible = false
                            leftPanel.visible = false
                            sddm.login(model.name, password, session)

                            bootani.start()
                        }

                        LoginBg {
                            id: loginBg

                            x: -3

                            LoginButton {
                                id: loginButton
                                visible: true

                                ToolTip {
                                    id: loginButtonTip

                                    delay: 1000
                                    timeout: 4800
                                    leftPadding: 9
                                    rightPadding: 9
                                    topPadding: 7
                                    bottomPadding: 7
                                    visible: loginButton.hovered

                                    contentItem: Text {
                                        text: "Submit"
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

                                onClicked: {
                                    loginButtonTip.hide()
                                    truePass.visible = true
                                    rightPanel.visible = false
                                    leftPanel.visible = false
                                    passwordField.visible = false
                                    passwordFieldPin.visible = false
                                    sddm.login(model.name, password, session)

                                    bootani.start()
                                }
                            }

                            RevealButton {
                                id: revealButton
                                visible: false
                            }
                        }
                    }

                    PasswordFieldPin {
                        id: passwordFieldPin
                        visible: config.PinMode === "off" ? false : true
                        enabled: config.PinMode === "off" ? false : true
                        focus: config.PinMode === "off" ? false : true

                        x: -135

                        validator: IntValidator { // this dude allows only numbers to be typed, if something goes wrong, blame this dude.
                            bottom: 8
                            top: 1000
                        }

                        anchors {
                            topMargin: 25
                            top: name.bottom
                        }

                        onTextChanged: {
                            if (passwordFieldPin.text !== "") {
                                passwordFieldPin.width = 257
                                revealButtonPin.x = passwordFieldPin.width
                                revealButtonPin.visible = true
                            }

                            else {
                                passwordFieldPin.width = 289
                                revealButtonPin.visible = false
                            }

                            if (passwordFieldPin.length > 3 ) {
                                rightPanel.visible = false
                                leftPanel.visible = false
                                sddm.login(model.name, password, session)

                                bootani.start()
                            }
                        }

                        LoginBg {
                            id: loginBgPin

                            x: -3

                            RevealButton {
                                id: revealButtonPin
                                visible: false
                            }
                        }
                    }

                    FalsePass {
                        id: falsePass
                        visible: false

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            topMargin: 25
                            top: name.bottom
                        }
                    }

                    Rectangle {
                        id: truePass
                        x: 1
                        y: 1
                        color: "transparent"
                        visible: false

                        Text {
                            id: welcome
                            color: "white"
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                            text: "Welcome"
                            renderType: Text.NativeRendering
                            font.weight: Font.DemiBold
                            font.pointSize: 17
                            anchors.centerIn: parent

                            leftPadding: 50
                            topPadding: 155
                        }

                        Rectangle {
                            id: trueButton
                            color: "transparent"

                            FontLoader {
                                id: animFont
                                source: Qt.resolvedUrl("fonts/SegoeBoot-Semilight.woff")
                            }

                            anchors.left: welcome.right
                            anchors.top: welcome.bottom

                            Text {
                                id: splash
                                color: "white"
                                text: ""
                                font.family: Qt.resolvedUrl("../fonts") ? "Segoe Boot Semilight" : animFont.name
                                renderType: Text.NativeRendering
                                font.weight: Font.Normal
                                font.pointSize: 24

                                topPadding: -25
                                leftPadding: -150

                                visible: true
                                // visible: animFont.status == FontLoader.Ready ? true : false

                                anchors {
                                    verticalCenter: parent.verticalCenter
                                }

                                SequentialAnimation {
                                    id: bootani
                                    running: false
                                    loops: Animation.Infinite

                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 1
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 2
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 3
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 4
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 5
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 6
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 7
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 8
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 9
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 10
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 11
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 12
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 13
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" //14
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 15
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 16
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 17
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 18
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 19
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 20
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 21
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 22
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 23
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 24
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 25
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" //26
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 27
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 28
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 29
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 30
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 31
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 32
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 33
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 34
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 35
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 36
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 37
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 38
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 39
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 40
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 41
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 42
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 43
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 44
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 45
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 46
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 47
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 48
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 49
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 50
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 51
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 52
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 53
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 54
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 55
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 56
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 57
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // sivas
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 59
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 60
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 61
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" //62
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 63
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 64
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 65
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 66
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 67
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 68
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // haha funni number
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 70
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 71
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 72
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 73
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 74
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 75
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 76
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 77
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 78
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 79
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 80
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 81
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 82
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 83
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 84
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" //85
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 86
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 87
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 88
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 89
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 90
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 91
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 92
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 93
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 94
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" //95
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 96
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 97
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 98
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 99
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 100
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 101
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 102
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 103
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 104
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 105
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 106
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 107
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 108
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 109
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 110
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 111
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 112
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 113
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 114
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 115
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 116
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 117
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 118
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 119
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 120
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 121
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 122
                                        duration: 30
                                    }
                                    PropertyAnimation {
                                        target: splash
                                        property: "text"
                                        to: "" // 123
                                        duration: 30
                                    }
                                }
                            }
                        }


                    }

                    CapsOn {
                        id: capsOn
                        visible: false

                        state: keyboard.capsLock ? "on" : "off"

                        states: [
                            State {
                                name: "on"
                                PropertyChanges {
                                    target: capsOn
                                    visible: true
                                }
                            },

                            State {
                                name: "off"
                                PropertyChanges {
                                    target: capsOn
                                    visible: false
                                }
                            }
                        ]

                        anchors {
                            top: passwordField.bottom
                            topMargin: 25
                        }
                    }
                }

            }

            Button {
                id: prevUser
                anchors.left: parent.left
                enabled: false
                visible: false
            }

            ListView {
                id: listView
                focus: true
                model: userModel
                delegate: userDelegate
                currentIndex: userModel.lastIndex
                interactive: false

                anchors {
                    left: prevUser.right
                    right: nextUser.left
                }
            }

            Button {
                id: nextUser
                anchors.right: parent.right
                enabled: false
                visible: false
            }
        }
    }

    Item {
        id: rightPanel
        z: 2
        opacity: 0

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 75
        }

        PowerPanel {
            id: powerPanel
        }

        SessionPanel {
            id: sessionPanel

            anchors {
                right: powerPanel.left
            }
        }

        LayoutPanel {
            id: layoutPanel

            anchors {
                right: sessionPanel.left
            }
        }
    }

    Rectangle {
        id: leftPanel
        color: "transparent"
        anchors.fill: parent
        z: 2
        opacity: 0

        visible: listView2.count > 1 ? true : false
        enabled: listView2.count > 1 ? true : false

        Component {
            id: userDelegate2

            UserList {
                id: userList
                name: (model.realName === "") ? model.name : model.realName
                icon: "/var/lib/AccountsService/icons/" + model.name
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView2.currentIndex = index
                        listView2.focus = true
                        listView.currentIndex = index
                        listView.focus = true
                    }
                }
            }
        }

        Rectangle {
            width: 150
            height: listView2.count > 17 ? Screen.height - 68 : 58 * listView2.count
            color: "transparent"
            clip: true

            anchors {
                bottom: parent.bottom
                bottomMargin: 35
                left: parent.left
                leftMargin: 35
            }

            Item {
                id: usersContainer2
                width: 255
                height: parent.height

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }

                Button {
                    id: prevUser2
                    visible: true
                    enabled: false
                    width: 0

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }
                }

                ListView {
                    id: listView2
                    height: parent.height
                    focus: true
                    model: userModel
                    currentIndex: userModel.lastIndex
                    delegate: userDelegate2
                    verticalLayoutDirection: ListView.TopToBottom
                    orientation: ListView.Vertical
                    interactive: listView2.count > 17 ? true : false

                    anchors {
                        left: prevUser2.right
                        right: nextUser2.left
                    }
                }

                Button {
                    id: nextUser2
                    visible: true
                    width: 0
                    enabled: false

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
                }
            }
        }
    }
}
