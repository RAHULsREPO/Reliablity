import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    anchors.fill: parent
    clip: true

    ColumnLayout {
        width: parent.width - 20
        spacing: 20

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 120
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Text {
                    text: "Welcome to " + window.selectedSubsystem + " Node Terminal"
                    color: "#00f0ff"
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "Segoe UI"
                }

                Text {
                    text: {
                        if (window.selectedSubsystem === "TFCS") return "Tactical Fire Control System controls weapons locking, stabilization, ballistic computations, and trigger execution systems.";
                        if (window.selectedSubsystem === "WCS") return "Weapons Control System manages armament inventory, safe-arm logic gates, payload configurations, and release authorizations.";
                        if (window.selectedSubsystem === "SIGINT") return "Signals Intelligence Node handles passive and active spectral scanning, decrypts telemetry channels, and parses raw RF signals.";
                        if (window.selectedSubsystem === "NAVSUITE") return "Navigation Suite tracks absolute GPS coordinates, gyroscopic orientation drift, and computes optimal route waypoints.";
                        if (window.selectedSubsystem === "RADAR") return "Radar Control System handles sweep rates, active transceivers, echo-rejection logic, and track correlations.";
                        if (window.selectedSubsystem === "UCS") return "Unified Communications System encrypts links, handles voice channels, and syncs tactical datalinks.";
                        if (window.selectedSubsystem === "SA") return "Situational Awareness Node tracks all contacts, identifies friend-or-foe status, and executes threat evaluations.";
                        return "Subsystem interface console.";
                    }
                    color: "#94a3b8"
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
            }
        }

        Text {
            text: "OPERATIONAL STATE OVERVIEW"
            color: "#64748b"
            font.pixelSize: 11
            font.bold: true
            font.family: "Segoe UI"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 130
                color: "#090e1a"
                border.color: "#1e293b"
                border.width: 1
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text { text: "HEALTH INDEX"; color: "#64748b"; font.pixelSize: 10; font.bold: true; font.family: "Segoe UI" }
                    Text {
                        text: {
                            if (window.subsystemStatus === "DEGRADED") return "DEGRADED (94%)";
                            if (window.subsystemStatus === "NOMINAL") return "NOMINAL (98%)";
                            return "EXCELLENT (100%)";
                        }
                        color: {
                            if (window.subsystemStatus === "DEGRADED") return "#f87171";
                            if (window.subsystemStatus === "NOMINAL") return "#fbbf24";
                            return "#34d399";
                        }
                        font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"
                    }
                    Text {
                        text: "System is operating within " + (window.subsystemStatus === "DEGRADED" ? "restricted" : "nominal") + " safety parameters."
                        color: "#64748b"
                        font.pixelSize: 11
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 130
                color: "#090e1a"
                border.color: "#1e293b"
                border.width: 1
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text { text: "TELEMETRY SYNC"; color: "#64748b"; font.pixelSize: 10; font.bold: true; font.family: "Segoe UI" }
                    Text { text: "125 Hz / ACTIVE"; color: "#00f0ff"; font.pixelSize: 18; font.bold: true; font.family: "Segoe UI" }
                    Text { text: "Data channels synced: Primary bus A, Backup bus B. Last sync: less than 1s ago."; color: "#64748b"; font.pixelSize: 11; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                }
            }
        }
    }
}
