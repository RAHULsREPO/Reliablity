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
            text: "TECHNICAL MANUALS & SYSTEM SCHEMATICS"
            color: "#00f0ff"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1
            font.family: "Segoe UI"
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 10

                Repeater {
                    model: [
                        {name: "Subsystem Operations Manual v5.4.2", type: "PDF Document", size: "4.8 MB"},
                        {name: "Reliability Block Design Diagram Schematic", type: "CAD Dwg File", size: "12.4 MB"},
                        {name: "LRU Interconnect Serial Protocol Spec", type: "PDF Specification", size: "1.2 MB"},
                        {name: "Failure Mode Effects Analysis (FMEA) Report", type: "Excel Spreadsheet", size: "3.5 MB"}
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 45
                        color: "#0d1527"
                        border.color: "#1e293b"
                        border.width: 1
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12

                            Text { text: "📄"; font.pixelSize: 16; Layout.preferredWidth: 30 }
                            ColumnLayout {
                                Layout.preferredWidth: 320
                                spacing: 2
                                Text { text: modelData.name; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                                Text { text: modelData.type; color: "#64748b"; font.pixelSize: 9 }
                            }

                            Text { text: modelData.size; color: "#94a3b8"; font.pixelSize: 11; Layout.preferredWidth: 100 }

                            Button {
                                id: btnDownload
                                implicitWidth: 80
                                implicitHeight: 26
                                background: Rectangle {
                                    color: btnDownload.hovered ? "#0e172a" : "#070b13"
                                    border.color: "#1e293b"
                                    border.width: 1
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: "DOWNLOAD"
                                    color: "#00f0ff"; font.pixelSize: 10; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: {
                                    // mock action
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
