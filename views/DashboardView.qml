import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    spacing: 15

    property alias historyData: chartCanvas.historyData

    RowLayout {
        Layout.fillWidth: true
        spacing: 15

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 65
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 6
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Text { text: "AVERAGE UPTIME"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                Text { text: window.subsystemUptime; color: "#ffffff"; font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 65
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 6
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Text { text: "ACTIVE ALERTS"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                Text {
                    text: window.subsystemFailures > 0 ? "⚠ " + window.subsystemFailures : "✓ OK";
                    color: window.subsystemFailures > 0 ? "#f87171" : "#34d399";
                    font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 65
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 6
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Text { text: "MTBF RATING"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                Text { text: window.subsystemMtbf; color: "#ffffff"; font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 65
            color: "#090e1a"
            border.color: "#1e293b"
            border.width: 1
            radius: 6
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 4
                Text { text: "OPERATING TEMP"; color: "#64748b"; font.pixelSize: 9; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter }
                Text {
                    text: window.subsystemTemp;
                    color: parseInt(window.subsystemTemp) > 50 ? "#f87171" : "#ffffff";
                    font.pixelSize: 18; font.bold: true; font.family: "Segoe UI"; Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "#090e1a"
        border.color: "#1e293b"
        border.width: 1
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text {
                text: "RELIABILITY CURVE (LAST 12 HOURS)"
                color: "#94a3b8"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
                font.family: "Segoe UI"
            }

            Canvas {
                id: chartCanvas
                Layout.fillWidth: true
                Layout.fillHeight: true

                property var historyData: []
                property real animFactor: 1.0

                onVisibleChanged: {
                    if (visible) requestPaint()
                }

                onHistoryDataChanged: {
                    chartCanvas.requestPaint()
                }

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    var w = width;
                    var h = height;
                    var paddingLeft = 40;
                    var paddingRight = 15;
                    var paddingTop = 15;
                    var paddingBottom = 25;
                    var chartW = w - paddingLeft - paddingRight;
                    var chartH = h - paddingTop - paddingBottom;

                    ctx.strokeStyle = "#1e293b";
                    ctx.lineWidth = 1;
                    ctx.font = "9px Segoe UI";
                    ctx.fillStyle = "#64748b";

                    var minVal = 90.0;
                    var maxVal = 100.0;
                    var gridCountY = 5;
                    for (var i = 0; i < gridCountY; i++) {
                        var val = minVal + (maxVal - minVal) * (i / (gridCountY - 1));
                        var y = h - paddingBottom - (i / (gridCountY - 1)) * chartH;
                        ctx.beginPath();
                        ctx.moveTo(paddingLeft, y);
                        ctx.lineTo(w - paddingRight, y);
                        ctx.stroke();
                        ctx.fillText(val.toFixed(1) + "%", 5, y + 3);
                    }

                    if (!historyData || historyData.length === 0) return;
                    var points = [];
                    var count = historyData.length;
                    for (var j = 0; j < count; j++) {
                        var val = historyData[j];
                        var normY = (val - minVal) / (maxVal - minVal);
                        if (normY < 0) normY = 0;
                        if (normY > 1) normY = 1;
                        var x = paddingLeft + (j / (count - 1)) * chartW;
                        var y = h - paddingBottom - normY * chartH;
                        points.push({x: x, y: y});
                    }

                    var gradient = ctx.createLinearGradient(0, paddingTop, 0, h - paddingBottom);
                    gradient.addColorStop(0, "rgba(0, 240, 255, 0.25)");
                    gradient.addColorStop(1, "rgba(0, 240, 255, 0.0)");

                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.moveTo(points[0].x, h - paddingBottom);
                    for (var k = 0; k < points.length; k++) {
                        ctx.lineTo(points[k].x, points[k].y);
                    }
                    ctx.lineTo(points[points.length - 1].x, h - paddingBottom);
                    ctx.closePath();
                    ctx.fill();

                    ctx.strokeStyle = "#00f0ff";
                    ctx.lineWidth = 2.5;
                    ctx.beginPath();
                    ctx.moveTo(points[0].x, points[0].y);
                    for (var k = 1; k < points.length; k++) {
                        ctx.lineTo(points[k].x, points[k].y);
                    }
                    ctx.stroke();

                    ctx.fillStyle = "#ffffff";
                    ctx.strokeStyle = "#0083b0";
                    ctx.lineWidth = 1.5;
                    for (var k = 0; k < points.length; k++) {
                        ctx.beginPath();
                        ctx.arc(points[k].x, points[k].y, 3, 0, 2 * Math.PI);
                        ctx.fill();
                        ctx.stroke();
                    }

                    ctx.fillStyle = "#64748b";
                    for (var k = 0; k < points.length; k += 2) {
                        var hour = (k * 2);
                        var label = (hour < 10 ? "0" : "") + hour + ":00";
                        ctx.fillText(label, points[k].x - 12, h - 8);
                    }
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 120
        color: "#050912"
        border.color: "#1e293b"
        border.width: 1
        radius: 6

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: "SYSTEM EVENT LOGS"
                color: "#64748b"
                font.pixelSize: 9
                font.bold: true
                font.family: "Segoe UI"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Repeater {
                    model: window.subsystemLogs
                    Text {
                        text: ">  " + modelData
                        color: "#34d399"
                        font.pixelSize: 11
                        font.family: "Consolas"
                        font.bold: true
                    }
                }
            }
        }
    }
}
