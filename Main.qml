import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
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
        source: Qt.resolvedUrl("fonts/iconfont.ttf")
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
                color: "#75000000"
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
            Item {
                id: keyboardContainer
                parent: root
                z: 100

                width: Screen.width / 2
                height: inputPanel.height

                x: (Screen.width - width) / 2
                y: (Screen.height / 2) + 150

                Rectangle {
                    id: dragBar
                    height: 30
                    width: parent.width
                    color: "white"
                    x: 8

                    anchors.bottom: inputPanel.top
                    anchors.bottomMargin: 0

                    state: "off"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.SizeAllCursor

                        drag.target: keyboardContainer
                        drag.axis: Drag.XAndYAxis
                        drag.minimumX: -Screen.width
                        drag.maximumX: Screen.width
                        drag.minimumY: -Screen.height
                        drag.maximumY: Screen.height
                    }

                    Image {
                        source: "Components/osk-icon.png"
                        width: 17
                        height: 17
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 8
                    }

                    Text {
                        text: "On-Screen Keyboard"
                        anchors.left: parent.left
                        anchors.leftMargin: 35
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black"
                        font.pointSize: 9
                        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                        renderType: Text.NativeRendering
                    }

                    Rectangle {
                        id: closeBtn
                        width: 46
                        height: parent.height - 1
                        anchors.right: parent.right
                        anchors.top: parent.top

                        color: closeT.containsMouse ? "#C42B1C" : "transparent"

                        Text {
                            text: "×"
                            color: closeT.containsMouse ? "white" : "#040404"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: -6
                            anchors.bottomMargin: 1
                            font.pixelSize: 27
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuil.name
                            renderType: Text.NativeRendering
                        }

                        MouseArea {
                            id: closeT
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            onClicked: {
                                keyboardText.text = "off"
                            }
                        }
                    }

                    Rectangle {
                        id: maxBtn
                        width: 46
                        height: parent.height - 1
                        anchors.right: closeBtn.left
                        anchors.top: parent.top

                        Text {
                            text: "▢"
                            color: "#80686868"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            font.pixelSize: 13
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuil.name
                            renderType: Text.NativeRendering
                        }

                        MouseArea {
                            id: maxT
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing: true
                        }
                    }

                    Rectangle {
                        id: minBtn
                        width: 46
                        height: parent.height - 1
                        anchors.right: maxBtn.left
                        anchors.top: parent.top

                        color: minT.containsMouse ? "#E9E9E9" : "transparent"

                        Text {
                            text: "–"
                            color: "#040404"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.bottomMargin: 1
                            font.pixelSize: 20
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuil.name
                            renderType: Text.NativeRendering
                        }

                        MouseArea {
                            id: minT
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            preventStealing: true

                            onClicked: {
                                keyboardText.text = "off"
                            }
                        }
                    }

                    states: [
                        State {
                            name: "on"
                            when: sessionText.text  === "on"
                            PropertyChanges { target: dragBar; visible: true; enabled: true }
                        },
                        State {
                            name: "off"
                            when: sessionText.text  === "off"
                            PropertyChanges { target: dragBar; visible: false; enabled: false }
                        }
                    ]
                }

                InputPanel {
                    id: inputPanel
                    width: parent.width
                    x: 8

                    states: [
                        State {
                            name: "on"
                            when: sessionText.text === "on"
                            PropertyChanges { target: inputPanel; visible: true; enabled: true }
                        },
                        State {
                            name: "off"
                            when: sessionText.text === "off"
                            PropertyChanges { target: inputPanel; visible: false; enabled: false }
                        }
                    ]
                }
            }
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

                    visible: ListView.isCurrentItem
                    enabled: ListView.isCurrentItem
                    height: 0
                    width: 296

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
                            keyboardText.text = "off"
                            truePass.visible = true
                            passwordField.visible = false
                            passwordFieldPin.visible = false
                            rightPanel.visible = false
                            leftPanel.visible = false
                            sddm.login(model.name, password, session)

                            bootani.start()

                            capsOn.z = -1
                        }

                        Keys.onEnterPressed: {
                            keyboardText.text = "off"
                            truePass.visible = true
                            passwordField.visible = false
                            passwordFieldPin.visible = false
                            rightPanel.visible = false
                            leftPanel.visible = false
                            sddm.login(model.name, password, session)

                            bootani.start()

                            capsOn.z = -1
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
                                    keyboardText.text = "off"
                                    loginButtonTip.hide()
                                    truePass.visible = true
                                    rightPanel.visible = false
                                    leftPanel.visible = false
                                    passwordField.visible = false
                                    passwordFieldPin.visible = false
                                    sddm.login(model.name, password, session)

                                    bootani.start()

                                    capsOn.z = -1
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

                        property int pinSize: config.PinSize

                        function calculateTopValue(size) {
                            return Math.pow(10, size) - 1;
                        }

                        validator: RegularExpressionValidator {
                            regularExpression: new RegExp("\\d{1," + passwordFieldPin.pinSize + "}")
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

                            if (config.PinSize === passwordFieldPin.length) {
                                keyboardText.text = "off"
                                falsePass.visible = true
                                passwordField.visible = false
                                passwordField.enabled = false
                                passwordFieldPin.visible = false
                                passwordFieldPin.enabled = false
                                rightPanel.visible = false
                                leftPanel.visible = false
                                sddm.login(model.name, password, session)

                                bootani.start()

                                capsOn.z = -1
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
                                source: Qt.resolvedUrl("fonts/segoeuiboot.woff")
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

                                BootAni {
                                    id: bootani
                                }
                            }
                        }
                    }

                    CapsOn {
                        id: capsOn
                        visible: false
                        z: 2

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
                                    z: -1
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

        Item {
            id: sessionPanel

            property int session: sessionList.currentIndex

            implicitHeight: sessionButton.height
            implicitWidth: sessionButton.width

            anchors {
                right: powerPanel.left
            }

            Text {
                id: sessionText
                text: keyboardText.text
                visible: false
            }

            DelegateModel {
                id: sessionWrapper
                model: sessionModel

                delegate: ItemDelegate {
                    id: sessionEntry
                    width: parent.width
                    height: 36
                    highlighted: sessionList.currentIndex == index

                    contentItem: Text {
                        renderType: Text.NativeRendering
                        font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                        font.pointSize: 10
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        text: name

                        Text {
                            id: offon
                            text: "Off"
                            color: "black"
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                            font.weight: Font.Bold
                            font.pointSize: 10
                            renderType: Text.NativeRendering

                            anchors {
                                verticalCenter: parent.verticalCenter
                                bottom: parent.top
                                bottomMargin: 5
                            }
                        }

                        Button {
                            id: sessionLever
                            width: 46
                            height: 15
                            z: 3

                            anchors {
                                top: parent.bottom
                                topMargin: 7
                                right: parent.right
                                rightMargin: 7
                            }

                            background: Rectangle {
                                id: sessionLeverBackground
                                color: "#A6A6A6"
                                border.color: "white"
                                border.width: 1
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    sessionList.currentIndex = index
                                }
                            }

                            Button {
                                id: leftblackLever
                                width: 12
                                height: 19

                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: -2
                                }

                                background: Rectangle {
                                    color: "black"
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {
                                        sessionList.currentIndex = index
                                    }
                                }
                            }

                            Button {
                                id: rightblackLever
                                width: 12
                                height: 19
                                visible: false

                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    right: parent.right
                                    rightMargin: -2
                                }

                                background: Rectangle {
                                    color: "black"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    sessionList.currentIndex = index
                                }
                            }
                        }

                        Button {
                            width: 50
                            height: 19

                            anchors {
                                top: parent.bottom
                                topMargin: 5
                                right: parent.right
                                rightMargin: 5
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    sessionList.currentIndex = index
                                }
                            }

                            background: Rectangle {
                                id: leverBack
                                color: "#A6A6A6"
                            }
                        }
                    }

                    background: Rectangle {
                        id: sessionEntryBackground
                        color: "transparent"
                    }

                    states: [
                        State {
                            name: "focused"
                            when: sessionEntry.focus

                            PropertyChanges {
                                target: sessionLeverBackground
                                color: config.color
                            }

                            PropertyChanges {
                                target: rightblackLever
                                    visible: true
                            }

                            PropertyChanges {
                                target: leftblackLever
                                visible: false
                            }
                            PropertyChanges {
                                target: offon
                                text: "On"
                            }
                        },

                        State {
                            name: "hovered"
                            when: sessionLever.hovered

                            PropertyChanges {
                                target: sessionLeverBackground
                                color: "#B5B5B5"
                            }
                        }
                    ]
                }
            }

            Button {
                id: sessionButton
                height: 50
                width: 50
                hoverEnabled: true

                Text {
                    color: "white"
                    font.family: Qt.resolvedUrl("../fonts") ? "Segoe MDL2 Assets" : iconfont.name
                    text: String.fromCodePoint(0xe776)
                    renderType: Text.NativeRendering
                    font.pointSize: sessionButton.height / 2
                    anchors.centerIn: sessionButton
                }

                ToolTip {
                    id: sessionButtonTip
                    delay: 1000
                    timeout: 4800
                    leftPadding: 9
                    rightPadding: 9
                    topPadding: 7
                    bottomPadding: 7
                    y: sessionButton.height + 5
                    z: 2
                    visible: sessionButton.hovered
                    contentItem: Text {
                        text: "Session"
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
                    id: sessionButtonBackground
                    color: "transparent"
                }

                states: [
                    State {
                        name: "pressed"
                        when: sessionButton.down

                        PropertyChanges {
                            target: sessionButtonBackground
                            color: "#33FFFFFF"
                        }
                    },

                    State {
                        name: "hovered"
                        when: sessionButton.hovered

                        PropertyChanges {
                            target: sessionButtonBackground
                            color: "#1AFFFFFF"
                        }
                    },

                    State {
                        name: "selection"
                        when: sessionPopup.visible

                        PropertyChanges {
                            target: sessionButtonBackground
                            color: "transparent"
                        }
                    }
                ]

                onClicked: {
                    sessionPopup.visible ? sessionPopup.close() : sessionPopup.open()
                    sessionPopup.visible === sessionPopup.open ; sessionButton.state = "selection"
                    sessionButtonTip.hide()
                }
            }

            Popup {
                id: sessionPopup
                width: 175
                height: 107
                x: Math.round((parent.width - width) / 2)
                y: Math.round(-sessionButton.height -(sessionPopup.height) + 45)
                z: 3
                topPadding: 5
                bottomPadding: 15
                leftPadding: 15
                rightPadding: 15
                background: Rectangle {
                    color: "white"
                    border.width: 1
                    border.color: "black"

                    Button  {
                        id: screenKeyboard
                        width: parent.width - 2
                        height: 41
                        x: 1
                        y: 65
                        z: 3
                        visible: true // i still don't but i figured something out :3
                        enabled: true

                        Text {
                            color: "black"
                            text: "On-Screen Keyboard"
                            renderType: Text.NativeRendering
                            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
                            font.pointSize: 10
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                leftMargin: 20
                            }
                        }

                        Text {
                            id: keyboardText
                            visible: false
                            color: "transparent"
                            text: "off"
                        }

                        states: [
                            State {
                                name: "hovered"
                                when: screenKeyboard.hovered

                                PropertyChanges {
                                    target: screenKeyboardBackground
                                    color: "#30000000"
                                }
                            },

                            State {
                                name: "on"

                                PropertyChanges {
                                    target: keyboardText
                                    text: "on"
                                }
                            },

                            State {
                                name: "off"

                                PropertyChanges {
                                    target: keyboardText
                                    text: "off"
                                }
                            }
                        ]

                        background: Rectangle {
                            id: screenKeyboardBackground
                            color: "transparent"
                        }

                        onClicked: {
                            if (keyboardText.text === "off") {
                                keyboardText.text = "on"
                            }
                            else {
                                keyboardText.text = "off"
                            }
                        }
                    }
                }

                contentItem: ListView {
                    id: sessionList
                    implicitHeight: contentHeight + 20
                    model: sessionWrapper
                    currentIndex: sessionModel.lastIndex
                    clip: true
                    spacing: 25
                    interactive: false
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
