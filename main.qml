import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
        chartCanvas.historyData = reliabilityController.getHistoryData(subName)
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
            id: dashboardView
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
                                    
                                    // Custom property to bind selection
                                    property bool isSelected: window.selectedSubsystem === modelData
                                    // Color mappings based on subsystem state for visual feedback
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

                                        // Highlight accent glow
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
                                    }
                                }
                            }
                        }

                        Item { Layout.fillHeight: true } // Spacer
                    }
                }

                // Right Workspace - Metrics Cards, Chart Canvas & Logs
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#070b13"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20

                        // Detail Header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Text {
                                text: window.selectedSubsystem
                                color: "#ffffff"
                                font.pixelSize: 22
                                font.bold: true
                                font.family: "Segoe UI"
                            }

                            Rectangle {
                                width: 80
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

                        // Summary Statistics Cards
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            // Card 1: Uptime
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 65
                                color: "#090e1a"
                                border.color: "#1e293b"
                                border.width: 1
                                radius: 6

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: "AVERAGE UPTIME"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: window.subsystemUptime; color: "#ffffff"; font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                }
                            }

                            // Card 2: Failure Alerts
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 65
                                color: "#090e1a"
                                border.color: "#1e293b"
                                border.width: 1
                                radius: 6

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: "ACTIVE ALERTS"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                    Text {
                                        text: window.subsystemFailures > 0 ? "⚠ " + window.subsystemFailures : "✓ OK";
                                        color: window.subsystemFailures > 0 ? "#f87171" : "#34d399";
                                        font.pixelSize: 18;
                                        font.bold: true;
                                        font.family: "Segoe UI";
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            // Card 3: MTBF
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 65
                                color: "#090e1a"
                                border.color: "#1e293b"
                                border.width: 1
                                radius: 6

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: "MTBF RATING"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: window.subsystemMtbf; color: "#ffffff"; font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                }
                            }

                            // Card 4: Operating Temp
                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 65
                                color: "#090e1a"
                                border.color: "#1e293b"
                                border.width: 1
                                radius: 6

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 4
                                    Text { text: "OPERATING TEMP"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                                    Text {
                                        text: window.subsystemTemp;
                                        color: parseInt(window.subsystemTemp) > 50 ? "#f87171" : "#ffffff";
                                        font.pixelSize: 18;
                                        font.bold: true;
                                        font.family: "Segoe UI";
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }

                        // Chart Workspace (Line Graph Canvas)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#090e1a"
                            border.color: "#1e293b"
                            border.width: 1
                            radius: 8

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 10

                                Text {
                                    text: "RELIABILITY CURVE (LAST 12 HOURS)"
                                    color: "#94a3b8"
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.letterSpacing: 1
                                    font.family: "Segoe UI"
                                }

                                Canvas {
                                    id: chartCanvas
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    property var historyData: []
                                    property real animFactor: 0.0

                                    // Refresh drawing when history changes
                                    onHistoryDataChanged: {
                                        animFactor = 0.0
                                        animFactor = 1.0
                                        chartCanvas.requestPaint()
                                    }

                                    onAnimFactorChanged: {
                                        chartCanvas.requestPaint()
                                    }

                                    onPaint: {
                                        var ctx = getContext("2d");
                                        ctx.reset();

                                        var w = width;
                                        var h = height;
                                        var paddingLeft = 40;
                                        var paddingRight = 15;
                                        var paddingTop = 15;
                                        var paddingBottom = 25;

                                        var chartW = w - paddingLeft - paddingRight;
                                        var chartH = h - paddingTop - paddingBottom;

                                        // Horizontal Grid lines & Y Axis Labels (Draw range: 90% - 100%)
                                        ctx.strokeStyle = "#1e293b";
                                        ctx.lineWidth = 1;
                                        ctx.font = "9px Segoe UI";
                                        ctx.fillStyle = "#64748b";

                                        var minVal = 90.0;
                                        var maxVal = 100.0;
                                        var gridCountY = 5;
                                        for (var i = 0; i < gridCountY; i++) {
                                            var val = minVal + (maxVal - minVal) * (i / (gridCountY - 1));
                                            var y = h - paddingBottom - (i / (gridCountY - 1)) * chartH;

                                            ctx.beginPath();
                                            ctx.moveTo(paddingLeft, y);
                                            ctx.lineTo(w - paddingRight, y);
                                            ctx.stroke();

                                            ctx.fillText(val.toFixed(1) + "%", 5, y + 3);
                                        }

                                        if (!historyData || historyData.length === 0) return;

                                        // Interpolate points coordinates
                                        var points = [];
                                        var count = historyData.length;
                                        for (var j = 0; j < count; j++) {
                                            var val = historyData[j];
                                            var normY = (val - minVal) / (maxVal - minVal);
                                            if (normY < 0) normY = 0;
                                            if (normY > 1) normY = 1;

                                            // Apply animation factor
                                            var animY = normY * animFactor;

                                            var x = paddingLeft + (j / (count - 1)) * chartW;
                                            var y = h - paddingBottom - animY * chartH;
                                            points.push({x: x, y: y});
                                        }

                                        // Draw Area gradient fill
                                        var gradient = ctx.createLinearGradient(0, paddingTop, 0, h - paddingBottom);
                                        gradient.addColorStop(0, "rgba(0, 240, 255, 0.25)");
                                        gradient.addColorStop(1, "rgba(0, 240, 255, 0.0)");

                                        ctx.fillStyle = gradient;
                                        ctx.beginPath();
                                        ctx.moveTo(points[0].x, h - paddingBottom);
                                        for (var k = 0; k < points.length; k++) {
                                            ctx.lineTo(points[k].x, points[k].y);
                                        }
                                        ctx.lineTo(points[points.length - 1].x, h - paddingBottom);
                                        ctx.closePath();
                                        ctx.fill();

                                        // Draw Line
                                        ctx.strokeStyle = "#00f0ff";
                                        ctx.lineWidth = 2.5;
                                        ctx.beginPath();
                                        ctx.moveTo(points[0].x, points[0].y);
                                        for (var k = 1; k < points.length; k++) {
                                            ctx.lineTo(points[k].x, points[k].y);
                                        }
                                        ctx.stroke();

                                        // Draw Point Circles
                                        ctx.fillStyle = "#ffffff";
                                        ctx.strokeStyle = "#0083b0";
                                        ctx.lineWidth = 1.5;
                                        for (var k = 0; k < points.length; k++) {
                                            ctx.beginPath();
                                            ctx.arc(points[k].x, points[k].y, 3, 0, 2 * Math.PI);
                                            ctx.fill();
                                            ctx.stroke();
                                        }

                                        // Draw X-axis timestamps
                                        ctx.fillStyle = "#64748b";
                                        for (var k = 0; k < points.length; k += 2) {
                                            var hour = (k * 2);
                                            var label = (hour < 10 ? "0" : "") + hour + ":00";
                                            ctx.fillText(label, points[k].x - 12, h - 8);
                                        }
                                    }

                                    Behavior on animFactor {
                                        NumberAnimation { duration: 600; easing.type: Easing.OutQuad }
                                    }
                                }
                            }
                        }

                        // Retro CRT Activity Log Console
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 120
                            color: "#050912"
                            border.color: "#1e293b"
                            border.width: 1
                            radius: 6

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                Text {
                                    text: "SYSTEM EVENT LOGS"
                                    color: "#64748b"
                                    font.pixelSize: 9
                                    font.bold: true
                                    font.family: "Segoe UI"
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Repeater {
                                        model: window.subsystemLogs

                                        Text {
                                            text: ">  " + modelData
                                            color: "#34d399"
                                            font.pixelSize: 11
                                            font.family: "Consolas"
                                            font.bold: true
                                        }
                                    }
                                }
                            }
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
            window.loadSubsystem("TFCS") // Default system load
        }
    }
}
