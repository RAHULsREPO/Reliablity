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
            text: "DEPOT INVENTORY & SPARES LEVELS TRACKER"
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
            Text { text: "SPARE PART DESCRIPTION"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 250 }
            Text { text: "ON-HAND QTY"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 120 }
            Text { text: "SAFETY STOCK LEVEL"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.preferredWidth: 150 }
            Text { text: "DEPOT LOCATION"; color: "#64748b"; font.pixelSize: 10; font.bold: true; Layout.fillWidth: true }
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
                    model: [
                        {desc: "Primary Compute Core Board v4.1", qty: 3, safety: 2, loc: "Depot Sector Green A-4"},
                        {desc: "Hot-Swap Power Supply Controller", qty: 5, safety: 3, loc: "Depot Sector Green B-12"},
                        {desc: "Shielded Communication Coaxial Relay", qty: 1, safety: 2, loc: "Depot Sector Yellow C-2"},
                        {desc: "System Chassis Fan Assembly 80mm", qty: 12, safety: 5, loc: "Depot Sector Green A-9"}
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        color: modelData.qty < modelData.safety ? "#1c1917" : "#0d1527"
                        border.color: modelData.qty < modelData.safety ? "#fbbf24" : "#1e293b"
                        border.width: 1
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10

                            Text { text: modelData.desc; color: "#ffffff"; font.pixelSize: 12; font.bold: true; Layout.preferredWidth: 250 }
                            Text {
                                text: modelData.qty + " Units";
                                color: modelData.qty < modelData.safety ? "#fbbf24" : "#ffffff";
                                font.pixelSize: 12; font.bold: true; Layout.preferredWidth: 120
                            }
                            Text { text: modelData.safety + " Units minimum"; color: "#64748b"; font.pixelSize: 11; Layout.preferredWidth: 150 }
                            Text { text: modelData.loc; color: "#94a3b8"; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }
    }
}
