import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "views"

ApplicationWindow {
    id: window
    title: "Secure Terminal | Tactical Console"
    width: 950
    height: 600
    minimumWidth: 950
    minimumHeight: 600
    visible: true
    visibility: Window.Maximized
    color: "#070b13"

    // Authentication state
    property bool loggedIn: false

    // Current selected subsystem metrics
    property string selectedSubsystem: "TFCS"
    property string subsystemStatus: "OPERATIONAL"
    property string subsystemUptime: "99.82%"
    property int subsystemFailures: 0
    property string subsystemMtbf: "4,500 hrs"
    property string subsystemTemp: "38°C"
    property var subsystemLogs: []

    // Navigation state
    property string currentSubView: "dashboard" // "home", "dashboard", "rbd", "rga", "lru_details", "lru_replacement", "lru_failures", "spares", "alerts", "documents"
    property bool inSubsystemMode: false      // Start in Master grid view, user clicks a subsystem to go inside
    property bool analyticsExpanded: true     // Expand/collapse state for Analytics sub-menu

    // Updates all stats and triggers chart repaint
    function loadSubsystem(subName) {
        selectedSubsystem = subName
        var stats = reliabilityController.getStats(subName)
        subsystemStatus = stats.status
        subsystemUptime = stats.uptime
        subsystemFailures = stats.failures
        subsystemMtbf = stats.mtbf
        subsystemTemp = stats.temp
        
        subsystemLogs = reliabilityController.getLogEntries(subName)
        dashboardView.historyData = reliabilityController.getHistoryData(subName)
    }

    Item {
        anchors.fill: parent

        // ==========================================
        // 1. LOCK / LOGIN SCREEN (visible when !loggedIn)
        // ==========================================
        RowLayout {
            id: loginView
            anchors.fill: parent
            spacing: 0
            visible: !window.loggedIn

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

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#cc000000" }
                        GradientStop { position: 0.4; color: "#22001a33" }
                        GradientStop { position: 1.0; color: "#f2070b13" }
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 1
                    color: "#1e293b"
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 15

                    Item { Layout.fillHeight: true }

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

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 8
                        Text {
                            text: "🛡"
                            font.pixelSize: 32
                            color: "#00f0ff"
                        }
                    }

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

                    ColumnLayout {
                        spacing: 16
                        Layout.fillWidth: true

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

                                onAccepted: btnLogin.clicked()
                            }
                        }
                    }

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
                                    feedbackText.text = "Security notice: Contact system administrators to reset credentials."
                                    feedbackBox.color = "#1c1917"
                                    feedbackBox.border.color = "#44403c"
                                    feedbackText.color = "#fbbf24"
                                    feedbackIcon.text = "ℹ"
                                }
                            }
                        }
                    }

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

        // ==========================================
        // 2. SUBSYSTEM RELIABILITY DASHBOARD (visible when loggedIn)
        // ==========================================
        ColumnLayout {
            id: mainConsoleView
            anchors.fill: parent
            spacing: 0
            visible: window.loggedIn

            // Top Header Bar
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 60
                color: "#090e1a"

                Rectangle {
                    anchors.bottom: parent.bottom
                    Layout.fillWidth: true
                    height: 1
                    color: "#1e293b"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 15

                    Text {
                        text: "🛡"
                        font.pixelSize: 22
                        color: "#00f0ff"
                    }

                    ColumnLayout {
                        spacing: 2
                        Text {
                            text: "TACTICAL BATTLEFIELD SYSTEM"
                            color: "#ffffff"
                            font.pixelSize: 15
                            font.bold: true
                            font.family: "Segoe UI"
                        }
                        Text {
                            text: "Subsystems Health & Reliability Matrix"
                            color: "#64748b"
                            font.pixelSize: 11
                            font.family: "Segoe UI"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 15

                        Rectangle {
                            width: 100
                            height: 28
                            color: "#0f172a"
                            border.color: "#334155"
                            border.width: 1
                            radius: 4

                            Text {
                                text: "OPERATOR: ADMIN"
                                color: "#94a3b8"
                                font.pixelSize: 10
                                font.bold: true
                                font.family: "Segoe UI"
                                anchors.centerIn: parent
                            }
                        }

                        // Logout Button
                        Button {
                            id: btnLogout
                            implicitWidth: 80
                            implicitHeight: 28

                            background: Rectangle {
                                radius: 4
                                color: btnLogout.hovered ? "#311010" : "#1b0a0a"
                                border.color: btnLogout.hovered ? "#ef4444" : "#991b1b"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: "LOGOUT"
                                color: btnLogout.hovered ? "#fecaca" : "#f87171"
                                font.pixelSize: 11
                                font.bold: true
                                font.family: "Segoe UI"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                window.loggedIn = false
                                txtUsername.text = ""
                                txtPassword.text = ""
                            }
                        }
                    }
                }
            }

            // Main Console Workspace
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Left Navigation - Subsystem Switcher Buttons
                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.fillHeight: true
                    color: "#0b101d"

                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: "#1e293b"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        // 1. Sidebar in master list mode (All Subsystems)
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: !window.inSubsystemMode
                            spacing: 10

                            Text {
                                text: "MONITORED NODES"
                                color: "#64748b"
                                font.pixelSize: 10
                                font.bold: true
                                font.letterSpacing: 1.5
                                font.family: "Segoe UI"
                                Layout.bottomMargin: 10
                            }

                            // Subsystem Buttons List
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Repeater {
                                    model: reliabilityController.subsystems

                                    Button {
                                        id: subBtn
                                        Layout.fillWidth: true
                                        implicitHeight: 48
                                        
                                        property bool isSelected: window.selectedSubsystem === modelData
                                        property string statusColor: {
                                            if (modelData === "SIGINT") return "#f87171"; // degraded
                                            if (modelData === "WCS") return "#fbbf24"; // nominal warning
                                            return "#34d399"; // operational
                                        }

                                        background: Rectangle {
                                            color: subBtn.isSelected ? "#131c33" : (subBtn.hovered ? "#0f172a" : "#070b13")
                                            border.color: subBtn.isSelected ? "#00f0ff" : "#1e293b"
                                            border.width: 1
                                            radius: 6

                                            Rectangle {
                                                anchors.left: parent.left
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                width: 4
                                                color: subBtn.statusColor
                                                visible: subBtn.isSelected
                                                radius: 2
                                            }

                                            Behavior on color { ColorAnimation { duration: 150 } }
                                        }

                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 15
                                            anchors.rightMargin: 15
                                            spacing: 10

                                            Rectangle {
                                                width: 6
                                                height: 6
                                                radius: 3
                                                color: subBtn.statusColor
                                            }

                                            Text {
                                                text: modelData
                                                color: subBtn.isSelected ? "#ffffff" : "#94a3b8"
                                                font.pixelSize: 13
                                                font.bold: true
                                                font.family: "Segoe UI"
                                            }

                                            Item { Layout.fillWidth: true }

                                            Text {
                                                text: {
                                                    if (modelData === "TFCS") return "99.8%";
                                                    if (modelData === "WCS") return "98.6%";
                                                    if (modelData === "SIGINT") return "94.1%";
                                                    if (modelData === "NAVSUITE") return "99.9%";
                                                    if (modelData === "RADAR") return "99.1%";
                                                    if (modelData === "UCS") return "99.4%";
                                                    if (modelData === "SA") return "99.7%";
                                                    return "100%";
                                                }
                                                color: subBtn.statusColor
                                                font.pixelSize: 11
                                                font.family: "Segoe UI"
                                            }
                                        }

                                        onClicked: {
                                            window.loadSubsystem(modelData)
                                            window.inSubsystemMode = true
                                            window.currentSubView = "dashboard"
                                        }
                                    }
                                }
                            }
                            Item { Layout.fillHeight: true }
                        }

                        // 2. Sidebar in subsystem detail mode
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.inSubsystemMode
                            spacing: 6

                            // Back Button
                            Button {
                                id: backBtn
                                Layout.fillWidth: true
                                implicitHeight: 32
                                background: Rectangle {
                                    color: backBtn.hovered ? "#1e293b" : "transparent"
                                    radius: 4
                                }
                                contentItem: RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    spacing: 8
                                    Text {
                                        text: "←"
                                        color: "#00f0ff"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                    Text {
                                        text: "All Subsystems"
                                        color: "#64748b"
                                        font.pixelSize: 12
                                        font.bold: true
                                        font.family: "Segoe UI"
                                    }
                                }
                                onClicked: {
                                    window.inSubsystemMode = false
                                }
                            }

                            // Subsystem Name Header
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 45
                                color: "#131c33"
                                border.color: "#00f0ff"
                                border.width: 1
                                radius: 6
                                Layout.topMargin: 5
                                Layout.bottomMargin: 10

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 15
                                    anchors.rightMargin: 15
                                    spacing: 8

                                    Rectangle {
                                        width: 8
                                        height: 8
                                        radius: 4
                                        color: {
                                            if (window.subsystemStatus === "DEGRADED") return "#f87171";
                                            if (window.subsystemStatus === "NOMINAL") return "#fbbf24";
                                            return "#34d399";
                                        }
                                    }

                                    Text {
                                        text: window.selectedSubsystem
                                        color: "#ffffff"
                                        font.pixelSize: 15
                                        font.bold: true
                                        font.family: "Segoe UI"
                                    }
                                }
                            }

                            ScrollView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true

                                ColumnLayout {
                                    width: parent.width - 15
                                    spacing: 4

                                    Button {
                                        id: menuHome
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "home"
                                        background: Rectangle {
                                            color: menuHome.active ? "#131c33" : (menuHome.hovered ? "#0f172a" : "transparent")
                                            border.color: menuHome.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "🏠"; color: menuHome.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Home"; color: menuHome.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuHome.active }
                                        }
                                        onClicked: window.currentSubView = "home"
                                    }

                                    Button {
                                        id: menuDashboard
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "dashboard"
                                        background: Rectangle {
                                            color: menuDashboard.active ? "#131c33" : (menuDashboard.hovered ? "#0f172a" : "transparent")
                                            border.color: menuDashboard.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "📊"; color: menuDashboard.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Dashboard"; color: menuDashboard.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuDashboard.active }
                                        }
                                        onClicked: window.currentSubView = "dashboard"
                                    }

                                    Button {
                                        id: menuRbd
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "rbd"
                                        background: Rectangle {
                                            color: menuRbd.active ? "#131c33" : (menuRbd.hovered ? "#0f172a" : "transparent")
                                            border.color: menuRbd.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "🔗"; color: menuRbd.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "RBD Diagram"; color: menuRbd.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuRbd.active }
                                        }
                                        onClicked: window.currentSubView = "rbd"
                                    }

                                    // Analytics Collapsible Header
                                    Button {
                                        id: menuAnalyticsHeader
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        background: Rectangle {
                                            color: menuAnalyticsHeader.hovered ? "#0f172a" : "transparent"
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "📈"; color: "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Analytics"; color: "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: true }
                                            Item { Layout.fillWidth: true }
                                            Text { text: window.analyticsExpanded ? "▼" : "▶"; color: "#64748b"; font.pixelSize: 10 }
                                        }
                                        onClicked: window.analyticsExpanded = !window.analyticsExpanded
                                    }

                                    // Sub-items inside Analytics
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        visible: window.analyticsExpanded
                                        spacing: 2
                                        Layout.leftMargin: 15

                                        Button {
                                            id: menuRga
                                            Layout.fillWidth: true
                                            implicitHeight: 34
                                            property bool active: window.currentSubView === "rga"
                                            background: Rectangle {
                                                color: menuRga.active ? "#131c33" : (menuRga.hovered ? "#0f172a" : "transparent")
                                                border.color: menuRga.active ? "#00f0ff" : "transparent"
                                                border.width: 1
                                                radius: 4
                                            }
                                            contentItem: RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 12
                                                spacing: 10
                                                Text { text: "📉"; color: menuRga.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 12 }
                                                Text { text: "RGA"; color: menuRga.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 12; font.family: "Segoe UI"; font.bold: menuRga.active }
                                            }
                                            onClicked: window.currentSubView = "rga"
                                        }
                                    }

                                    // Remaining Main Menu Items
                                    Button {
                                        id: menuLruDetails
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "lru_details"
                                        background: Rectangle {
                                            color: menuLruDetails.active ? "#131c33" : (menuLruDetails.hovered ? "#0f172a" : "transparent")
                                            border.color: menuLruDetails.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "📋"; color: menuLruDetails.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "LRU Details"; color: menuLruDetails.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuLruDetails.active }
                                        }
                                        onClicked: window.currentSubView = "lru_details"
                                    }

                                    Button {
                                        id: menuLruReplacement
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "lru_replacement"
                                        background: Rectangle {
                                            color: menuLruReplacement.active ? "#131c33" : (menuLruReplacement.hovered ? "#0f172a" : "transparent")
                                            border.color: menuLruReplacement.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "🔄"; color: menuLruReplacement.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "LRU Replacement"; color: menuLruReplacement.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuLruReplacement.active }
                                        }
                                        onClicked: window.currentSubView = "lru_replacement"
                                    }

                                    Button {
                                        id: menuLruFailures
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "lru_failures"
                                        background: Rectangle {
                                            color: menuLruFailures.active ? "#131c33" : (menuLruFailures.hovered ? "#0f172a" : "transparent")
                                            border.color: menuLruFailures.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "⚠️"; color: menuLruFailures.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "LRU Failures"; color: menuLruFailures.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuLruFailures.active }
                                        }
                                        onClicked: window.currentSubView = "lru_failures"
                                    }

                                    Button {
                                        id: menuSpares
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "spares"
                                        background: Rectangle {
                                            color: menuSpares.active ? "#131c33" : (menuSpares.hovered ? "#0f172a" : "transparent")
                                            border.color: menuSpares.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "📦"; color: menuSpares.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Spares"; color: menuSpares.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuSpares.active }
                                        }
                                        onClicked: window.currentSubView = "spares"
                                    }

                                    Button {
                                        id: menuAlerts
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "alerts"
                                        background: Rectangle {
                                            color: menuAlerts.active ? "#131c33" : (menuAlerts.hovered ? "#0f172a" : "transparent")
                                            border.color: menuAlerts.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "🔔"; color: menuAlerts.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Alerts"; color: menuAlerts.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuAlerts.active }
                                        }
                                        onClicked: window.currentSubView = "alerts"
                                    }

                                    Button {
                                        id: menuDocuments
                                        Layout.fillWidth: true
                                        implicitHeight: 36
                                        property bool active: window.currentSubView === "documents"
                                        background: Rectangle {
                                            color: menuDocuments.active ? "#131c33" : (menuDocuments.hovered ? "#0f172a" : "transparent")
                                            border.color: menuDocuments.active ? "#00f0ff" : "transparent"
                                            border.width: 1
                                            radius: 4
                                        }
                                        contentItem: RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 12
                                            spacing: 10
                                            Text { text: "📄"; color: menuDocuments.active ? "#00f0ff" : "#94a3b8"; font.pixelSize: 13 }
                                            Text { text: "Documents"; color: menuDocuments.active ? "#ffffff" : "#94a3b8"; font.pixelSize: 13; font.family: "Segoe UI"; font.bold: menuDocuments.active }
                                        }
                                        onClicked: window.currentSubView = "documents"
                                    }
                                }
                            }
                        }
                    }
                }

                // Right Workspace - Grid overview or detailed panels
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#070b13"

                    // Master View: Grid of all subsystems
                    SubsystemsGridView {
                        anchors.fill: parent
                        anchors.margins: 20
                        visible: !window.inSubsystemMode
                    }

                    // Detail View: Display selected subsystem node console
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        visible: window.inSubsystemMode
                        spacing: 15

                        // Subsystem Page Detail Header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Text {
                                text: window.selectedSubsystem + " > " + window.currentSubView.toUpperCase()
                                color: "#ffffff"
                                font.pixelSize: 20
                                font.bold: true
                                font.family: "Segoe UI"
                            }

                            Rectangle {
                                width: 90
                                height: 20
                                radius: 4
                                color: {
                                    if (window.subsystemStatus === "DEGRADED") return "#450a0a";
                                    if (window.subsystemStatus === "NOMINAL") return "#1c1917";
                                    return "#064e3b";
                                }
                                border.color: {
                                    if (window.subsystemStatus === "DEGRADED") return "#f87171";
                                    if (window.subsystemStatus === "NOMINAL") return "#fbbf24";
                                    return "#34d399";
                                }
                                border.width: 1

                                Text {
                                    text: window.subsystemStatus
                                    color: {
                                        if (window.subsystemStatus === "DEGRADED") return "#f87171";
                                        if (window.subsystemStatus === "NOMINAL") return "#fbbf24";
                                        return "#34d399";
                                    }
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    anchors.centerIn: parent
                                }
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: "REALTIME TELEMETRY CONNECTED"
                                color: "#00f0ff"
                                font.pixelSize: 10
                                font.bold: true
                                font.family: "Segoe UI"
                            }
                        }

                        // Component Subviews Container
                        HomeView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "home"
                        }

                        DashboardView {
                            id: dashboardView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "dashboard"
                        }

                        RbdDiagramView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "rbd"
                        }

                        RgaView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "rga"
                        }

                        LruDetailsView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "lru_details"
                        }

                        LruReplacementView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "lru_replacement"
                        }

                        LruFailuresView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "lru_failures"
                        }

                        SparesView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "spares"
                        }

                        AlertsView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "alerts"
                        }

                        DocumentsView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: window.currentSubView === "documents"
                        }
                    }
                }
            }
        }
    }

    // Connections to handle C++ login checks
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
                txtPassword.text = ""
                
                loginSuccessTimer.start()
            } else {
                feedbackBox.color = "#450a0a"
                feedbackBox.border.color = "#991b1b"
                feedbackText.color = "#fecaca"
                feedbackIcon.text = "⚠"
                feedbackIcon.color = "#f87171"
            }
        }
    }

    Timer {
        id: loginSuccessTimer
        interval: 1000
        repeat: false
        onTriggered: {
            window.loggedIn = true
            feedbackText.text = ""
            window.inSubsystemMode = false
            window.loadSubsystem("TFCS") // Default system load
        }
    }
}
