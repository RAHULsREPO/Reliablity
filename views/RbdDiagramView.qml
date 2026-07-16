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
            text: "RELIABILITY BLOCK DIAGRAM (RBD) MODEL"
            color: "#00f0ff"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1
            font.family: "Segoe UI"
        }

        Text {
            text: "Diagram shows parallel and series redundancy models of the subsystem. Green lines show active path loops."
            color: "#64748b"
            font.pixelSize: 12
            font.family: "Segoe UI"
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 30

            Rectangle {
                width: 100
                height: 80
                color: "#0f172a"
                border.color: "#34d399"
                border.width: 2
                radius: 6

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "INPUT LINK"; color: "#ffffff"; font.bold: true; font.pixelSize: 11; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "R = 0.999"; color: "#34d399"; font.pixelSize: 10; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle { width: 40; height: 2; color: "#34d399" }

            ColumnLayout {
                spacing: 20

                Rectangle {
                    width: 120
                    height: 60
                    color: "#0f172a"
                    border.color: "#34d399"
                    border.width: 2
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        Text { text: "PROCESSOR A"; color: "#ffffff"; font.bold: true; font.pixelSize: 10; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "ACTIVE"; color: "#34d399"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                        Text { text: "R = 0.995"; color: "#94a3b8"; font.pixelSize: 9; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                    }
                }

                Rectangle {
                    width: 120
                    height: 60
                    color: "#0f172a"
                    border.color: window.subsystemStatus === "DEGRADED" ? "#f87171" : "#fbbf24"
                    border.width: 2
                    radius: 6

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 2
                        Text { text: "PROCESSOR B"; color: "#ffffff"; font.bold: true; font.pixelSize: 10; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                        Text {
                            text: window.subsystemStatus === "DEGRADED" ? "OFFLINE (FAULT)" : "STANDBY";
                            color: window.subsystemStatus === "DEGRADED" ? "#f87171" : "#fbbf24";
                            font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter
                        }
                        Text { text: "R = 0.995"; color: "#94a3b8"; font.pixelSize: 9; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }

            Rectangle { width: 40; height: 2; color: "#34d399" }

            Rectangle {
                width: 100
                height: 80
                color: "#0f172a"
                border.color: "#34d399"
                border.width: 2
                radius: 6

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "OUTPUT CONTROLLER"; color: "#ffffff"; font.bold: true; font.pixelSize: 10; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "R = 0.998"; color: "#34d399"; font.pixelSize: 10; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 70
            color: "#0f172a"
            border.color: "#1e293b"
            border.width: 1
            radius: 6

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Text {
                    text: "SYSTEM RELIABILITY CALCULATION:"
                    color: "#64748b"
                    font.pixelSize: 9
                    font.bold: true; font.family: "Segoe UI"
                }

                Text {
                    text: {
                        var base = "R_sys = R_input × [1 - (1 - R_processorA) × (1 - R_processorB)] × R_output";
                        if (window.subsystemStatus === "DEGRADED") {
                            return base + "\nActive calculation (faulted standby processor): R_sys = 0.999 × 0.995 × 0.998 = " + (0.999 * 0.995 * 0.998).toFixed(5);
                        }
                        return base + "\nActive calculation (dual parallel processors): R_sys = 0.999 × [1 - 0.005²] × 0.998 = 0.999 × 0.99997 × 0.998 = " + (0.999 * 0.999975 * 0.998).toFixed(5);
                    }
                    color: "#34d399"
                    font.pixelSize: 11
                    font.family: "Consolas"
                    Layout.fillWidth: true
                }
            }
        }
    }
}
