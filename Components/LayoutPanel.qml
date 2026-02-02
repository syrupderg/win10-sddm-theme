import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: layoutButton.height
    implicitWidth: layoutButton.width

    signal valueChanged(int id)

    // all of this is because keyboard.layouts[keyboard.currentLayout].shortName doesn't work btw. https://github.com/sddm/sddm/issues/2153
    function getLayoutCode(longName) {
        if (!longName) return "??";

        var cleanName = longName.toLowerCase().trim();

        var match = cleanName.match(/\(([^)]+)\)/);
        if (match) {
            return match[1].toUpperCase().substring(0, 2);
        }

        const map = {
            "american": "US",
            "arabic": "SA",
            "australian": "AU",
            "austrian": "AT",
            "belgian": "BE",
            "brazilian": "BR",
            "british": "GB",
            "bulgarian": "BG",
            "canadian": "CA",
            "chinese": "CN",
            "croatian": "HR",
            "czech": "CZ",
            "danish": "DK",
            "dutch": "NL",
            "english": "US",
            "estonian": "EE",
            "farsi": "IR",
            "filipino": "PH",
            "finnish": "FI",
            "french": "FR",
            "german": "DE",
            "greek": "GR",
            "hebrew": "IL",
            "hindi": "IN",
            "hungarian": "HU",
            "icelandic": "IS",
            "indonesian": "ID",
            "irish": "IE",
            "italian": "IT",
            "japanese": "JP",
            "korean": "KR",
            "latvian": "LV",
            "lithuanian": "LT",
            "malay": "MY",
            "mexican": "MX",
            "newzealand": "NZ",
            "norwegian": "NO",
            "polish": "PL",
            "portuguese": "PT",
            "romanian": "RO",
            "russian": "RU",
            "serbian": "RS",
            "slovak": "SK",
            "slovenian": "SI",
            "spanish": "ES",
            "swedish": "SE",
            "swiss": "CH",
            "thai": "TH",
            "turkish": "TR",
            "ukrainian": "UA",
            "vietnamese": "VN"
        };

        if (map[cleanName]) return map[cleanName];

        return longName.substring(0, 2).toUpperCase();
    }

    onValueChanged: (id) => {
        keyboard.currentLayout = id
    }

    DelegateModel {
        id: layoutWrapper
        model: keyboard.layouts
        delegate: ItemDelegate {
            id: layoutEntry
            width: parent.width
            height: 34
            highlighted: layoutList.currentIndex == index

            contentItem: Text {
                renderType: Text.NativeRendering
                font.family: Qt.resolvedUrl("fonts/segoeui.ttf")
                font.pointSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                color: "white"
                text: modelData.longName
            }

            background: Rectangle {
                id: layoutEntryBackground
                color: "transparent"
            }

            states: [
                State {
                    name: "focused"
                    when: layoutEntry.focus
                    PropertyChanges {
                        target: layoutEntryBackground
                        color: config.color
                    }
                },
                State {
                    name: "hovered"
                    when: layoutEntry.hovered
                    PropertyChanges {
                        target: layoutEntryBackground
                        color: "#343434"
                    }
                }
            ]

            MouseArea {
                anchors.fill: parent
                onPressed: layoutEntryBackground.color = "#35FFFFFF"
                onReleased: {
                    if (layoutEntry.focus) layoutEntryBackground.color = config.color
                    else layoutEntryBackground.color = "#1E1E1E"
                }
                onClicked: {
                    layoutList.currentIndex = index
                    layoutPopup.close()
                    valueChanged(layoutList.currentIndex)
                }
            }
        }
    }

    Button {
        id: layoutButton
        height: 50
        width: 50
        hoverEnabled: true

        Text {
            color: "white"
            text: getLayoutCode(keyboard.layouts[keyboard.currentLayout].longName)

            font.family: Qt.resolvedUrl("../fonts") ? "Segoe UI" : segoeui.name
            renderType: Text.NativeRendering
            font.capitalization: Font.AllUppercase
            font.pointSize: 12

            anchors {
                horizontalCenter: layoutButton.horizontalCenter
                verticalCenter: layoutButton.verticalCenter
            }
        }

        ToolTip {
            id: layoutButtonTip
            delay: 1000
            timeout: 4800
            leftPadding: 9
            rightPadding: 9
            topPadding: 7
            bottomPadding: 7
            y: layoutButton.height + 5
            z: 2
            visible: layoutButton.hovered

            contentItem: Text {
                text: keyboard.layouts[keyboard.currentLayout].longName
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
            id: layoutButtonBackground
            color: "transparent"
        }

        states: [
            State {
                name: "pressed"
                when: layoutButton.down
                PropertyChanges { target: layoutButtonBackground; color: "#33FFFFFF" }
            },
            State {
                name: "hovered"
                when: layoutButton.hovered
                PropertyChanges { target: layoutButtonBackground; color: "#1AFFFFFF" }
            },
            State {
                name: "selection"
                when: layoutPopup.visible
                PropertyChanges { target: layoutButtonBackground; color: "transparent" }
            }
        ]

        onClicked: {
            layoutPopup.visible ? layoutPopup.close() : layoutPopup.open()
            layoutButton.state = "selection"
            layoutButtonTip.hide()
        }
    }

    Popup {
        id: layoutPopup
        width: 121
        x: Math.round((parent.width - width) / 2)
        y: Math.round(-layoutButton.height -(layoutPopup.height) + 45)
        topPadding: 5
        bottomPadding: 5
        leftPadding: 0
        rightPadding: 0

        background: Rectangle {
            color: "#1E1E1E"
        }

        contentItem: ListView {
            id: layoutList
            implicitHeight: contentHeight
            model: layoutWrapper
            currentIndex: keyboard.currentLayout
            clip: true
            interactive: false
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; easing.type: Easing.OutCirc }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; easing.type: Easing.OutCirc }
        }
    }
}
