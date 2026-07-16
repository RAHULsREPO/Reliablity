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
            text: "SUB-SYSTEM COMPONENT FAILURE EVENT HISTORIES"
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
            Text { text: "TIMESTAMP"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 120 }
            Text { text: "COMPONENT"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 150 }
            Text { text: "FAILURE MODE / DESCRIPTION"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 230 }
            Text { text: "DOWNTIME"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 45
                    color: "#180f12"
                    border.color: "#991b1b"
                    border.width: 1
                    radius: 4

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        Text { text: "2026-07-10 22:12"; color: "#fca5a5"; font.pixelSize: 11; Layout.preferredWidth: 120 }
                        Text { text: "Processor Module B"; color: "#ffffff"; font.pixelSize: 11; font.bold: true; Layout.preferredWidth: 150 }
                        Text { text: "Critical memory parity fault error detected."; color: "#fecaca"; font.pixelSize: 11; Layout.preferredWidth: 230 }
                        Text { text: "12 min (Automatic bypass active)"; color: "#fca5a5"; font.pixelSize: 11 }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 45
                    color: "#0d1527"
                    border.color: "#1e293b"
                    border.width: 1
                    radius: 4

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10

                        Text { text: "2026-05-18 04:30"; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 120 }
                        Text { text: "Primary Power Supply"; color: "#ffffff"; font.pixelSize: 11; font.bold: true; Layout.preferredWidth: 150 }
                        Text { text: "Secondary voltage sag threshold warning."; color: "#cbd5e1"; font.pixelSize: 11; Layout.preferredWidth: 230 }
                        Text { text: "0 min (Compensated)"; color: "#34d399"; font.pixelSize: 11 }
                    }
                }
            }
        }
    }
}
