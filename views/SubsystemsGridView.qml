import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: gridScroll
    clip: true

    ColumnLayout {
        width: gridScroll.availableWidth - 25
        spacing: 20

        Text {
            text: "OVERVIEW | ALL MONITORED NODES"
            color: "#00f0ff"
            font.pixelSize: 18
            font.bold: true
            font.letterSpacing: 2
            font.family: "Segoe UI"
        }

        GridLayout {
            columns: gridScroll.width > 900 ? 3 : (gridScroll.width > 600 ? 2 : 1)
            rowSpacing: 15
            columnSpacing: 15
            Layout.fillWidth: true

            Repeater {
                model: reliabilityController.subsystems

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 160
                    color: "#090e1a"
                    border.color: "#1e293b"
                    border.width: 1
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            window.loadSubsystem(modelData)
                            window.inSubsystemMode = true
                            window.currentSubView = "home"
                        }
                        onEntered: parent.border.color = "#00f0ff"
                        onExited: parent.border.color = "#1e293b"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 8

                        RowLayout {
                            Text {
                                text: modelData
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.bold: true
                                font.family: "Segoe UI"
                            }
                            Item { Layout.fillWidth: true }
                            Rectangle {
                                width: 80
                                height: 18
                                radius: 4
                                color: {
                                    if (modelData === "SIGINT") return "#450a0a";
                                    if (modelData === "WCS") return "#1c1917";
                                    return "#064e3b";
                                }
                                border.color: {
                                    if (modelData === "SIGINT") return "#f87171";
                                    if (modelData === "WCS") return "#fbbf24";
                                    return "#34d399";
                                }
                                border.width: 1
                                Text {
                                    text: {
                                        if (modelData === "SIGINT") return "DEGRADED";
                                        if (modelData === "WCS") return "NOMINAL";
                                        return "OPERATIONAL";
                                    }
                                    color: {
                                        if (modelData === "SIGINT") return "#f87171";
                                        if (modelData === "WCS") return "#fbbf24";
                                        return "#34d399";
                                    }
                                    font.pixelSize: 9
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    anchors.centerIn: parent
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#1e293b"
                        }

                        RowLayout {
                            ColumnLayout {
                                spacing: 2
                                Text { text: "UPTIME"; color: "#64748b"; font.pixelSize: 9; font.family: "Segoe UI" }
                                Text {
                                    text: {
                                        if (modelData === "TFCS") return "99.82%";
                                        if (modelData === "WCS") return "98.65%";
                                        if (modelData === "SIGINT") return "94.12%";
                                        if (modelData === "NAVSUITE") return "99.98%";
                                        if (modelData === "RADAR") return "99.15%";
                                        if (modelData === "UCS") return "99.42%";
                                        if (modelData === "SA") return "99.70%";
                                        return "100%";
                                    }
                                    color: "#ffffff"
                                    font.pixelSize: 14; font.bold: true; font.family: "Segoe UI"
                                }
                            }
                            Item { Layout.fillWidth: true }
                            ColumnLayout {
                                spacing: 2
                                Text { text: "TEMP"; color: "#64748b"; font.pixelSize: 9; font.family: "Segoe UI" }
                                Text {
                                    text: {
                                        if (modelData === "TFCS") return "38°C";
                                        if (modelData === "WCS") return "45°C";
                                        if (modelData === "SIGINT") return "52°C";
                                        if (modelData === "NAVSUITE") return "34°C";
                                        if (modelData === "RADAR") return "49°C";
                                        if (modelData === "UCS") return "40°C";
                                        if (modelData === "SA") return "36°C";
                                        return "0°C";
                                    }
                                    color: {
                                        if (modelData === "SIGINT") return "#f87171";
                                        return "#ffffff";
                                    }
                                    font.pixelSize: 14; font.bold: true; font.family: "Segoe UI"
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }

                        Text {
                            text: "Click to enter node console →"
                            color: "#00f0ff"
                            font.pixelSize: 11
                            font.bold: true
                            font.family: "Segoe UI"
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }
        }
    }
}
