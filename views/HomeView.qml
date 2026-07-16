import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: homeScroll
    anchors.fill: parent
    clip: true
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AsNeeded

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        spacing: 25

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 90
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 6

                Text {
                    text: "SUBMARINE MASTER CONTROL PANEL"
                    color: "#00f0ff"
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "Segoe UI"
                }

                Text {
                    text: "Reliability, Availability, & Maintainability (RAM) metrics tracking 7 core vessel subsystems."
                    color: "#94a3b8"
                    font.pixelSize: 13
                    font.family: "Segoe UI"
                }
            }
        }

        Text {
            text: "CORE SUBSYSTEMS STATUS & METRICS"
            color: "#64748b"
            font.pixelSize: 11
            font.bold: true
            font.family: "Segoe UI"
            Layout.topMargin: 5
        }

        GridLayout {
            columns: homeScroll.width > 950 ? 3 : (homeScroll.width > 650 ? 2 : 1)
            columnSpacing: 20
            rowSpacing: 20
            Layout.fillWidth: true

            Repeater {
                model: reliabilityController.subsystems

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 230
                    color: window.selectedSubsystem === modelData ? "#131c33" : "#090e1a"
                    border.color: window.selectedSubsystem === modelData ? "#00f0ff" : "#1e293b"
                    border.width: 1
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            window.loadSubsystem(modelData)
                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: modelData
                                color: "#ffffff"
                                font.pixelSize: 18
                                font.bold: true
                                font.family: "Segoe UI"
                            }

                            Rectangle {
                                width: 85
                                height: 20
                                radius: 4
                                color: {
                                    var stats = reliabilityController.getStats(modelData);
                                    if (stats.status === "DEGRADED") return "#450a0a";
                                    if (stats.status === "NOMINAL") return "#1c1917";
                                    return "#064e3b";
                                }
                                border.color: {
                                    var stats = reliabilityController.getStats(modelData);
                                    if (stats.status === "DEGRADED") return "#f87171";
                                    if (stats.status === "NOMINAL") return "#fbbf24";
                                    return "#34d399";
                                }
                                border.width: 1

                                Text {
                                    text: {
                                        var stats = reliabilityController.getStats(modelData);
                                        return stats.status;
                                    }
                                    color: {
                                        var stats = reliabilityController.getStats(modelData);
                                        if (stats.status === "DEGRADED") return "#f87171";
                                        if (stats.status === "NOMINAL") return "#fbbf24";
                                        return "#34d399";
                                    }
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    anchors.centerIn: parent
                                }
                            }

                            Item { Layout.fillWidth: true }
                        }

                        Text {
                            text: {
                                if (modelData === "TFCS") return "Tactical Fire Control System - weapons locking, stabilizer, ballistics & trigger.";
                                if (modelData === "WCS") return "Weapons Control System - armaments, launch & release logic.";
                                if (modelData === "SIGINT") return "Signals Intelligence - spectral scanning & RF telemetry decryption.";
                                if (modelData === "NAVSUITE") return "Navigation Suite - absolute GPS, drift compensation & route mapping.";
                                if (modelData === "RADAR") return "Radar Control - active transceivers, echo-rejection & track correlation.";
                                if (modelData === "UCS") return "Unified Communications - link encryption & secure datalinks.";
                                if (modelData === "SA") return "Situational Awareness - contacts tracking & threat evaluation.";
                                return "Subsystem node.";
                            }
                            color: "#94a3b8"
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            lineHeight: 1.2
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

                        GridLayout {
                            columns: 2
                            rowSpacing: 6
                            columnSpacing: 15
                            Layout.fillWidth: true

                            Text { text: "Uptime:"; color: "#64748b"; font.pixelSize: 11; font.family: "Segoe UI" }
                            Text { text: reliabilityController.getStats(modelData).uptime; color: "#ffffff"; font.pixelSize: 11; font.bold: true; font.family: "Segoe UI" }

                            Text { text: "MTBF:"; color: "#64748b"; font.pixelSize: 11; font.family: "Segoe UI" }
                            Text { text: reliabilityController.getStats(modelData).uptime.replace("%", "") === "99.98" ? "8,500 hrs" : reliabilityController.getStats(modelData).mtbf; color: "#ffffff"; font.pixelSize: 11; font.bold: true; font.family: "Segoe UI" }

                            Text { text: "Temperature:"; color: "#64748b"; font.pixelSize: 11; font.family: "Segoe UI" }
                            Text { text: reliabilityController.getStats(modelData).temp; color: "#ffffff"; font.pixelSize: 11; font.bold: true; font.family: "Segoe UI" }
                        }
                    }
                }
            }
        }
    }
}
