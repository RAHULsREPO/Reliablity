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
            text: "RELIABILITY GROWTH ANALYSIS (RGA) - DUANE MODEL"
            color: "#00f0ff"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 1
            font.family: "Segoe UI"
        }

        Text {
            text: "Duane growth plot representing cumulative MTBF vs cumulative test hours. Upward slope confirms positive reliability growth parameters."
            color: "#64748b"
            font.pixelSize: 12
            font.family: "Segoe UI"
        }

        Canvas {
            id: rgaCanvas
            Layout.fillWidth: true
            Layout.fillHeight: true

            onVisibleChanged: {
                if (visible) requestPaint()
            }

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                var w = width;
                var h = height;
                var paddingLeft = 45;
                var paddingRight = 15;
                var paddingTop = 15;
                var paddingBottom = 25;
                var chartW = w - paddingLeft - paddingRight;
                var chartH = h - paddingTop - paddingBottom;

                ctx.strokeStyle = "#1e293b";
                ctx.lineWidth = 1;
                ctx.fillStyle = "#64748b";
                ctx.font = "8px Segoe UI";

                var gridCount = 5;
                for (var i = 0; i < gridCount; i++) {
                    var yVal = 1000 + i * 1000;
                    var y = h - paddingBottom - (i / (gridCount - 1)) * chartH;
                    ctx.beginPath();
                    ctx.moveTo(paddingLeft, y);
                    ctx.lineTo(w - paddingRight, y);
                    ctx.stroke();
                    ctx.fillText(yVal + " hr", 5, y + 3);

                    var xVal = 100 + i * 225;
                    var x = paddingLeft + (i / (gridCount - 1)) * chartW;
                    ctx.beginPath();
                    ctx.moveTo(x, paddingTop);
                    ctx.lineTo(x, h - paddingBottom);
                    ctx.stroke();
                    ctx.fillText(xVal + " hr", x - 15, h - 8);
                }

                ctx.strokeStyle = "#00f0ff";
                ctx.lineWidth = 2.5;
                ctx.beginPath();
                
                var points = [];
                for (var j = 0; j < 10; j++) {
                    var xPercent = j / 9;
                    var xCoord = paddingLeft + xPercent * chartW;
                    var growthFactor = Math.pow(1.0 + xPercent * 3.0, 0.45);
                    var yPercent = (1200 * growthFactor - 1000) / 4000;
                    var yCoord = h - paddingBottom - yPercent * chartH;
                    points.push({x: xCoord, y: yCoord});
                }

                ctx.moveTo(points[0].x, points[0].y);
                for (var k = 1; k < points.length; k++) {
                    ctx.lineTo(points[k].x, points[k].y);
                }
                ctx.stroke();

                ctx.fillStyle = "#fbbf24";
                for (var k = 0; k < points.length; k++) {
                    var noise = (k === 0 || k === points.length - 1) ? 0 : (Math.sin(k * 2) * 8);
                    ctx.beginPath();
                    ctx.arc(points[k].x, points[k].y + noise, 4, 0, 2 * Math.PI);
                    ctx.fill();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 50
                color: "#0f172a"
                radius: 6
                border.color: "#1e293b"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text { text: "GROWTH PARAMETER (ALPHA)"; color: "#64748b"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "0.485 (EXCELLENT)"; color: "#34d399"; font.pixelSize: 14; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 50
                color: "#0f172a"
                radius: 6
                border.color: "#1e293b"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text { text: "INITIAL MTBF"; color: "#64748b"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "1,250 hrs"; color: "#ffffff"; font.pixelSize: 14; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 50
                color: "#0f172a"
                radius: 6
                border.color: "#1e293b"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text { text: "CURRENT CUMULATIVE MTBF"; color: "#64748b"; font.pixelSize: 8; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    Text { text: window.subsystemMtbf; color: "#00f0ff"; font.pixelSize: 14; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }
}
