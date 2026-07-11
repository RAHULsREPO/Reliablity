import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    title: "Secure Terminal | Admin Portal"
    width: 950
    height: 600
    minimumWidth: 950
    minimumHeight: 600
    maximumWidth: 950
    maximumHeight: 600
    visible: true
    color: "#070b13"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Panel - Cybersecurity Graphic Section
        Rectangle {
            Layout.preferredWidth: 450
            Layout.fillHeight: true
            color: "#000000"
            clip: true

            Image {
                id: bgImage
                source: "qrc:/cybersecurity_bg.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: 0.85

                // Subtle entry zoom effect
                Component.onCompleted: {
                    zoomAnim.start()
                }

                NumberAnimation {
                    id: zoomAnim
                    target: bgImage
                    property: "scale"
                    from: 1.05
                    to: 1.0
                    duration: 2000
                    easing.type: Easing.OutQuad
                }
            }

            // Tech Gradient Overlay
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#cc000000" }
                    GradientStop { position: 0.4; color: "#22001a33" }
                    GradientStop { position: 1.0; color: "#f2070b13" }
                }
            }

            // Glow Line Accent
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#1e293b"
            }

            // Overlay Text Information
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 15

                Item { Layout.fillHeight: true } // Spacer pushing text to the bottom

                RowLayout {
                    spacing: 8
                    Rectangle {
                        width: 4
                        height: 18
                        color: "#00f0ff"
                        radius: 2
                    }
                    Text {
                        text: "CORE SECURE"
                        color: "#00f0ff"
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 2
                        font.family: "Segoe UI"
                    }
                }

                Text {
                    text: "INTELLIGENT DEFENSE PLATFORM"
                    color: "#ffffff"
                    font.pixelSize: 28
                    font.bold: true
                    font.family: "Segoe UI"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                Text {
                    text: "Operational Security Level: CRITICAL\nReal-time monitoring active. Unauthorized access attempt will log the source IP."
                    color: "#94a3b8"
                    font.pixelSize: 13
                    lineHeight: 1.3
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                RowLayout {
                    spacing: 10
                    Layout.topMargin: 10

                    Rectangle {
                        id: statusIndicator
                        width: 8
                        height: 8
                        radius: 4
                        color: "#00ff66"

                        SequentialAnimation on color {
                            loops: Animation.Infinite
                            ColorAnimation { from: "#00ff66"; to: "#053018"; duration: 1200 }
                            ColorAnimation { from: "#053018"; to: "#00ff66"; duration: 1200 }
                        }
                    }

                    Text {
                        text: "SECURE CHANNEL STATUS: ENCRYPTED"
                        color: "#00ff66"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                        font.family: "Segoe UI"
                    }
                }
            }
        }

        // Right Panel - Login Form Section
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#070b13"

            ColumnLayout {
                anchors.centerIn: parent
                width: 380
                spacing: 24

                // Logo/Icon Placeholder
                RowLayout {
                    Layout.alignment: Qt.AlignLeft
                    spacing: 8
                    Text {
                        text: "🛡"
                        font.pixelSize: 32
                        color: "#00f0ff"
                    }
                }

                // Form Headers
                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    Text {
                        text: "Secure Authentication"
                        color: "#ffffff"
                        font.pixelSize: 24
                        font.bold: true
                        font.family: "Segoe UI"
                    }

                    Text {
                        text: "Enter operator credentials to verify console access."
                        color: "#64748b"
                        font.pixelSize: 13
                        font.family: "Segoe UI"
                    }
                }

                // Input Fields
                ColumnLayout {
                    spacing: 16
                    Layout.fillWidth: true

                    // Username
                    ColumnLayout {
                        spacing: 6
                        Layout.fillWidth: true

                        Text {
                            text: "OPERATOR ID"
                            color: "#94a3b8"
                            font.pixelSize: 10
                            font.bold: true
                            font.letterSpacing: 1
                            font.family: "Segoe UI"
                        }

                        TextField {
                            id: txtUsername
                            placeholderText: "admin"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.family: "Segoe UI"
                            Layout.fillWidth: true
                            selectByMouse: true
                            selectedTextColor: "#ffffff"
                            selectionColor: "#0f52ba"
                            placeholderTextColor: "#475569"

                            background: Rectangle {
                                implicitHeight: 44
                                color: txtUsername.activeFocus ? "#0e1626" : "#0b101d"
                                border.color: txtUsername.activeFocus ? "#00f0ff" : "#1e293b"
                                border.width: 1
                                radius: 6

                                Behavior on border.color { ColorAnimation { duration: 150 } }
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }
                    }

                    // Password
                    ColumnLayout {
                        spacing: 6
                        Layout.fillWidth: true

                        Text {
                            text: "SECURITY KEYCODE"
                            color: "#94a3b8"
                            font.pixelSize: 10
                            font.bold: true
                            font.letterSpacing: 1
                            font.family: "Segoe UI"
                        }

                        TextField {
                            id: txtPassword
                            placeholderText: "••••••••"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.family: "Segoe UI"
                            echoMode: TextInput.Password
                            Layout.fillWidth: true
                            selectByMouse: true
                            selectedTextColor: "#ffffff"
                            selectionColor: "#0f52ba"
                            placeholderTextColor: "#475569"

                            background: Rectangle {
                                implicitHeight: 44
                                color: txtPassword.activeFocus ? "#0e1626" : "#0b101d"
                                border.color: txtPassword.activeFocus ? "#00f0ff" : "#1e293b"
                                border.width: 1
                                radius: 6

                                Behavior on border.color { ColorAnimation { duration: 150 } }
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }

                            // Press Enter key to trigger login
                            onAccepted: btnLogin.clicked()
                        }
                    }
                }

                // Remember me & Forgot Link
                RowLayout {
                    Layout.fillWidth: true

                    CheckBox {
                        id: chkRemember
                        spacing: 8
                        indicator: Rectangle {
                            implicitWidth: 18
                            implicitHeight: 18
                            x: chkRemember.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 4
                            color: "#0b101d"
                            border.color: chkRemember.checked ? "#00f0ff" : "#1e293b"
                            border.width: 1

                            Rectangle {
                                width: 10
                                height: 10
                                x: 4
                                y: 4
                                radius: 2
                                color: "#00f0ff"
                                visible: chkRemember.checked
                            }
                        }

                        contentItem: Text {
                            text: "Remember ID"
                            color: "#94a3b8"
                            font.pixelSize: 12
                            font.family: "Segoe UI"
                            leftPadding: chkRemember.indicator.width + chkRemember.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "Forgot passkey?"
                        color: "#00f0ff"
                        font.pixelSize: 12
                        font.family: "Segoe UI"
                        font.underline: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                feedbackText.text = "Security notice: Contact system administrators at support@securecorp.com to reset credentials."
                                feedbackBox.color = "#1c1917"
                                feedbackBox.border.color = "#44403c"
                                feedbackText.color = "#fbbf24"
                                feedbackIcon.text = "ℹ"
                            }
                        }
                    }
                }

                // Action Button
                Button {
                    id: btnLogin
                    Layout.fillWidth: true
                    implicitHeight: 46

                    background: Rectangle {
                        radius: 6
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: btnLogin.hovered ? "#00e0ff" : "#00b4db" }
                            GradientStop { position: 1.0; color: btnLogin.hovered ? "#0066ff" : "#0083b0" }
                        }
                        border.color: "#00f0ff"
                        border.width: btnLogin.activeFocus ? 2 : 0

                        scale: btnLogin.pressed ? 0.98 : 1.0
                        Behavior on scale { NumberAnimation { duration: 80 } }
                    }

                    contentItem: Text {
                        text: "ESTABLISH SESSION"
                        color: "#ffffff"
                        font.pixelSize: 13
                        font.bold: true
                        font.letterSpacing: 1.5
                        font.family: "Segoe UI"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        loginController.login(txtUsername.text, txtPassword.text)
                    }
                }

                // Status Notification Box
                Rectangle {
                    id: feedbackBox
                    Layout.fillWidth: true
                    implicitHeight: feedbackText.text !== "" ? 56 : 0
                    color: "#070b13"
                    border.width: feedbackText.text !== "" ? 1 : 0
                    radius: 6
                    clip: true

                    Behavior on implicitHeight {
                        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10

                        Text {
                            id: feedbackIcon
                            text: ""
                            font.pixelSize: 16
                            font.bold: true
                            Layout.alignment: Qt.AlignTop
                        }

                        Text {
                            id: feedbackText
                            text: ""
                            color: "#ffffff"
                            font.pixelSize: 12
                            font.family: "Segoe UI"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: loginController
        function onLoginResult(success, message) {
            feedbackText.text = message
            if (success) {
                feedbackBox.color = "#064e3b"
                feedbackBox.border.color = "#047857"
                feedbackText.color = "#a7f3d0"
                feedbackIcon.text = "✓"
                feedbackIcon.color = "#34d399"
                
                // Clear password on success
                txtPassword.text = ""
            } else {
                feedbackBox.color = "#450a0a"
                feedbackBox.border.color = "#991b1b"
                feedbackText.color = "#fecaca"
                feedbackIcon.text = "⚠"
                feedbackIcon.color = "#f87171"
            }
        }
    }
}
