import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
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

        FontLoader {
            id: localsys
            source: "/usr/local/share/fonts/s/SegMDL2.ttf"
        }

        Text {
            id: warning
            visible: {
                if (segoeui.status === FontLoader.Error && localsys.status === FontLoader.Error) return true

                return false
            }

            color: "white"
            font.pointSize: 19
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuisb.name
            font.weight: Font.DemiBold
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignLeft
            text: "Please install the required fonts!"
            bottomPadding: 400

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: warning2
            visible: warning.visible ? true : false

            color: "white"
            font.pointSize: 19
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuisb.name
            font.weight: Font.DemiBold
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignLeft
            text: "Check the Github repo from 'https://github.com/birbkeks/win10-sddm-theme' "
            bottomPadding: 250

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: warning3
            visible: warning.visible ? true : false

            color: "white"
            font.pointSize: 19
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuisb.name
            font.weight: Font.DemiBold
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignLeft
            text: "or run '/usr/share/sddm/themes/win10-sddm-theme/install.sh' in your terminal!"
            bottomPadding: 200

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: warning4
            visible: warning.visible ? true : false

            color: "white"
            font.pointSize: 19
            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI Light" : segoeuisb.name
            font.weight: Font.DemiBold
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignLeft
            text: "I can't include those fonts in my project because of legal issues with Microsoft!"
            bottomPadding: 50

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
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

    Item {
        id: centerPanel
        anchors.centerIn: root
        z: 2
        opacity: 0

        Item {

            Component {
                id: userDelegate

                UserPanel {
                    anchors.centerIn: parent
                    name: (model.realName === "") ? model.name : model.realName
                    icon: "/var/lib/AccountsService/icons/" + model.name
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
}
