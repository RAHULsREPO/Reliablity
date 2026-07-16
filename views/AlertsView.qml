import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: alertsRootPanel
    color: "#090e1a"
    border.color: "#1e293b"
    border.width: 1
    radius: 8

    property var alarms: [
        {time: "22:12", desc: "Dual processor sync latency threshold limit exceeded", sev: "CRITICAL", ack: false},
        {time: "19:04", desc: "Operational battery voltage level charging alert", sev: "WARNING", ack: false}
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "ACTIVE SYSTEM DIAGNOSTIC ALARMS"
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
                    model: alertsRootPanel.alarms

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 50
                        color: modelData.ack ? "#064e3b" : (modelData.sev === "CRITICAL" ? "#450a0a" : "#1c1917")
                        border.color: modelData.ack ? "#34d399" : (modelData.sev === "CRITICAL" ? "#f87171" : "#fbbf24")
                        border.width: 1
                        radius: 6

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12

                            Rectangle {
                                width: 6; height: 6; radius: 3
                                color: modelData.sev === "CRITICAL" ? "#f87171" : "#fbbf24"
                            }

                            ColumnLayout {
                                Layout.preferredWidth: 350
                                spacing: 2
                                Text { text: modelData.desc; color: "#ffffff"; font.bold: true; font.pixelSize: 12 }
                                Text { text: "Raised at " + modelData.time; color: "#94a3b8"; font.pixelSize: 9 }
                            }

                            Text {
                                text: modelData.sev;
                                color: modelData.sev === "CRITICAL" ? "#f87171" : "#fbbf24";
                                font.pixelSize: 11; font.bold: true; Layout.preferredWidth: 100
                            }

                            Button {
                                id: btnAck
                                implicitWidth: 80
                                implicitHeight: 26
                                background: Rectangle {
                                    color: btnAck.hovered ? "#312e81" : "#1e1b4b"
                                    border.color: "#00f0ff"
                                    border.width: 1
                                    radius: 4
                                }
                                contentItem: Text {
                                    text: modelData.ack ? "ACKNOWLEDGED" : "ACK ALARM"
                                    color: "#ffffff"; font.pixelSize: 10; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: {
                                    modelData.ack = true;
                                    alertsRootPanel.alarms[index] = modelData;
                                    var copy = alertsRootPanel.alarms;
                                    alertsRootPanel.alarms = [];
                                    alertsRootPanel.alarms = copy;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
