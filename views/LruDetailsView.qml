import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "#090e1a"
    border.color: "#1e293b"
    border.width: 1
    radius: 8

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "LINE REPLACEABLE UNIT (LRU) INVENTORY METRICS"
            color: "#00f0ff"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1
            font.family: "Segoe UI"
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Text { text: "LRU COMPONENT NAME"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 200 }
            Text { text: "SERIAL NUMBER"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 150 }
            Text { text: "OPERATIONAL HEALTH"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 150 }
            Text { text: "OPERATING TEMP"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 10

                Repeater {
                    model: {
                        if (window.selectedSubsystem === "TFCS") return ["Ballistic Compute Unit", "Dual-Channel Comm Link", "Direct Fire Link Relay"];
                        if (window.selectedSubsystem === "WCS") return ["Missile Launch Controller", "Safe-Arm Board", "Secondary Power Supply Block"];
                        if (window.selectedSubsystem === "SIGINT") return ["RF Processing Matrix", "Spectral Scanning Module", "Backup Thermal Shield"];
                        return ["Core Compute Block", "Channel Interface Card", "Power Distribution Bus"];
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        color: index % 2 === 0 ? "#0d1527" : "transparent"
                        border.color: "#1e293b"
                        border.width: 1
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10

                            Text { text: modelData; color: "#ffffff"; font.pixelSize: 12; font.bold: true; Layout.preferredWidth: 200; font.family: "Segoe UI" }
                            Text { text: "SN-" + (83729 + index * 492); color: "#94a3b8"; font.pixelSize: 12; Layout.preferredWidth: 150; font.family: "Consolas" }
                            
                            RowLayout {
                                Layout.preferredWidth: 150
                                spacing: 6
                                Rectangle {
                                    width: 8; height: 8; radius: 4
                                    color: (window.subsystemStatus === "DEGRADED" && index === 1) ? "#f87171" : "#34d399"
                                }
                                Text {
                                    text: (window.subsystemStatus === "DEGRADED" && index === 1) ? "FAULTED" : "NOMINAL"
                                    color: (window.subsystemStatus === "DEGRADED" && index === 1) ? "#f87171" : "#34d399"
                                    font.pixelSize: 11; font.bold: true; font.family: "Segoe UI"
                                }
                            }

                            Text {
                                text: (34 + index * 4) + "°C";
                                color: (34 + index * 4) > 42 ? "#fbbf24" : "#ffffff";
                                font.pixelSize: 12; font.family: "Segoe UI"
                            }
                        }
                    }
                }
            }
        }
    }
}
