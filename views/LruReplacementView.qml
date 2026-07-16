import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: lruReplacementRoot
    color: "#090e1a"
    border.color: "#1e293b"
    border.width: 1
    radius: 8

    property var replacementLogs: [
        "2026-06-12 14:02: Ballistic Compute Unit A (SN-83729) replaced by Operator Admin (Scheduled Preventative Maintenance)",
        "2026-04-03 09:44: Secondary Power Supply Block B (SN-84713) replaced by Operator Admin (Due to thermal threshold alert)"
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "MAINTENANCE & LRU REPLACEMENT RECORDS"
            color: "#00f0ff"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1
            font.family: "Segoe UI"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text { text: "EXECUTE QUICK PREVENTATIVE REPLACEMENT"; color: "#94a3b8"; font.pixelSize: 11; font.bold: true }

                Button {
                    id: btnReplaceLRU
                    Layout.fillWidth: true
                    implicitHeight: 40
                    background: Rectangle {
                        color: btnReplaceLRU.hovered ? "#0066ff" : "#0052cc"
                        radius: 6
                    }
                    contentItem: Text {
                        text: "🔧 REPLACE SELECTED PRIMARY LRU MODULE"
                        color: "#ffffff"; font.bold: true; font.pixelSize: 12; font.family: "Segoe UI"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        var now = new Date();
                        var dateString = now.getFullYear() + "-" + 
                                         ("0" + (now.getMonth() + 1)).slice(-2) + "-" + 
                                         ("0" + now.getDate()).slice(-2) + " " + 
                                         ("0" + now.getHours()).slice(-2) + ":" + 
                                         ("0" + now.getMinutes()).slice(-2);
                        var newLog = dateString + ": Primary Module (SN-92817) Hot-Swapped successfully by Operator Admin.";
                        lruReplacementRoot.replacementLogs.unshift(newLog);
                        var copy = lruReplacementRoot.replacementLogs;
                        lruReplacementRoot.replacementLogs = [];
                        lruReplacementRoot.replacementLogs = copy;
                    }
                }
            }

            Rectangle {
                width: 1; height: 60; color: "#1e293b"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Text { text: "LAST HOT-SWAP RESULT"; color: "#64748b"; font.pixelSize: 9 }
                Text { text: "SUCCESSFUL"; color: "#34d399"; font.pixelSize: 16; font.bold: true }
                Text { text: "Primary and secondary sync matches complete. Interconnect active."; color: "#94a3b8"; font.pixelSize: 10 }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#1e293b" }

        Text { text: "REPLACEMENT WORK ORDER LOG"; color: "#64748b"; font.pixelSize: 10; font.bold: true }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width - 15
                spacing: 8

                Repeater {
                    model: lruReplacementRoot.replacementLogs
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 45
                        color: "#0d1527"
                        border.color: "#1e293b"
                        border.width: 1
                        radius: 4

                        Text {
                            text: modelData
                            color: "#e2e8f0"
                            font.pixelSize: 11
                            font.family: "Segoe UI"
                            anchors.fill: parent
                            anchors.margins: 10
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }
}
