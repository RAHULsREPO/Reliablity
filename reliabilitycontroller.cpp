#include "reliabilitycontroller.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

ReliabilityController::ReliabilityController(QObject *parent) : QObject(parent)
{
    m_subsystems << "TFCS" << "WCS" << "SIGINT" << "NAVSUITE" << "RADAR" << "UCS" << "SA";
}

QStringList ReliabilityController::subsystems() const
{
    return m_subsystems;
}

QVariantList ReliabilityController::getHistoryData(const QString &subsystem)
{
    QVariantList data;
    if (subsystem == "TFCS") {
        data << 99.8 << 99.8 << 99.7 << 99.9 << 99.8 << 99.8 << 99.9 << 99.8 << 99.7 << 99.9 << 99.8 << 99.82;
    } else if (subsystem == "WCS") {
        data << 98.1 << 98.4 << 98.2 << 98.5 << 98.6 << 98.5 << 98.9 << 98.7 << 98.3 << 98.8 << 98.7 << 98.65;
    } else if (subsystem == "SIGINT") {
        data << 96.4 << 95.8 << 96.0 << 95.1 << 94.8 << 94.2 << 93.9 << 94.5 << 94.1 << 94.6 << 94.3 << 94.12;
    } else if (subsystem == "NAVSUITE") {
        data << 99.9 << 99.9 << 99.9 << 100.0 << 99.9 << 100.0 << 99.9 << 99.9 << 100.0 << 99.9 << 100.0 << 99.98;
    } else if (subsystem == "RADAR") {
        data << 98.9 << 99.1 << 98.8 << 99.2 << 99.0 << 99.3 << 99.1 << 99.4 << 99.0 << 99.2 << 99.3 << 99.15;
    } else if (subsystem == "UCS") {
        data << 99.2 << 99.3 << 99.2 << 99.5 << 99.4 << 99.6 << 99.5 << 99.3 << 99.4 << 99.5 << 99.4 << 99.42;
    } else if (subsystem == "SA") {
        data << 99.5 << 99.6 << 99.5 << 99.8 << 99.7 << 99.7 << 99.8 << 99.6 << 99.7 << 99.8 << 99.7 << 99.70;
    } else {
        // Fallback default
        data << 95.0 << 96.0 << 97.0 << 98.0 << 99.0 << 100.0;
    }
    return data;
}

QVariantMap ReliabilityController::getStats(const QString &subsystem)
{
    QVariantMap stats;
    if (subsystem == "TFCS") {
        stats["status"] = "OPERATIONAL";
        stats["uptime"] = "99.82%";
        stats["failures"] = 0;
        stats["mtbf"] = "4,500 hrs";
        stats["temp"] = "38°C";
    } else if (subsystem == "WCS") {
        stats["status"] = "NOMINAL";
        stats["uptime"] = "98.65%";
        stats["failures"] = 1;
        stats["mtbf"] = "3,200 hrs";
        stats["temp"] = "45°C";
    } else if (subsystem == "SIGINT") {
        stats["status"] = "DEGRADED";
        stats["uptime"] = "94.12%";
        stats["failures"] = 3;
        stats["mtbf"] = "1,200 hrs";
        stats["temp"] = "52°C";
    } else if (subsystem == "NAVSUITE") {
        stats["status"] = "OPERATIONAL";
        stats["uptime"] = "99.98%";
        stats["failures"] = 0;
        stats["mtbf"] = "8,500 hrs";
        stats["temp"] = "34°C";
    } else if (subsystem == "RADAR") {
        stats["status"] = "OPERATIONAL";
        stats["uptime"] = "99.15%";
        stats["failures"] = 0;
        stats["mtbf"] = "2,800 hrs";
        stats["temp"] = "49°C";
    } else if (subsystem == "UCS") {
        stats["status"] = "NOMINAL";
        stats["uptime"] = "99.42%";
        stats["failures"] = 0;
        stats["mtbf"] = "5,500 hrs";
        stats["temp"] = "40°C";
    } else if (subsystem == "SA") {
        stats["status"] = "OPERATIONAL";
        stats["uptime"] = "99.70%";
        stats["failures"] = 0;
        stats["mtbf"] = "6,000 hrs";
        stats["temp"] = "36°C";
    }
    return stats;
}

QVariantList ReliabilityController::getLogEntries(const QString &subsystem)
{
    QVariantList logs;
    if (subsystem == "TFCS") {
        logs << "TFCS: Core computer initialization sequence active..."
             << "TFCS: Ballistic trajectory library synced successfully."
             << "TFCS: High-rate data link verification complete: OK"
             << "TFCS: System ready. Awaiting targeting command.";
    } else if (subsystem == "WCS") {
        logs << "WCS: Safe/Arm logic circuits self-test completed."
             << "WCS: Warning: Missile bay #2 pneumatic pressure nominal threshold limit."
             << "WCS: Secondary batteries switched to standby state."
             << "WCS: Armament verification checked: 1 warning, 0 faults.";
    } else if (subsystem == "SIGINT") {
        logs << "SIGINT: Signal processing matrix initialized."
             << "SIGINT: Re-routing processor board 3 to core backup node."
             << "SIGINT: Warning: Thermal peak detected on SIGINT board 3 (52°C)."
             << "SIGINT: Band scanning active: Heavy atmospheric interference detected.";
    } else if (subsystem == "NAVSUITE") {
        logs << "NAVSUITE: Gyroscopic IMU pitch/roll alignment finalized."
             << "NAVSUITE: Satellite triangulation acquisition locked (12 signals)."
             << "NAVSUITE: Drift compensation auto-adjusted: drift rate < 0.001 deg/hr"
             << "NAVSUITE: Navigation logs fully synchronized with master log database.";
    } else if (subsystem == "RADAR") {
        logs << "RADAR: Active transmitter phase matrix array enabled."
             << "RADAR: Sea-clutter rejection logic configured."
             << "RADAR: Active tracking matrix active; sweep rate set to 60 RPM."
             << "RADAR: Transceiver status: NOMINAL.";
    } else if (subsystem == "UCS") {
        logs << "UCS: Audio/data cryptographic keys updated."
             << "UCS: Secure satellite datalink Link-16 sync successful."
             << "UCS: Main antenna transceiver calibrated to channel 4."
             << "UCS: High frequency emergency channels checked.";
    } else if (subsystem == "SA") {
        logs << "SA: Tactical situation computer core online."
             << "SA: Real-time track correlation table loaded."
             << "SA: Threat detection threshold evaluation verified."
             << "SA: Currently tracking 14 contacts (10 friendly, 4 neutral).";
    }
    return logs;
}

QVariantList ReliabilityController::getLruDetails(const QString &subsystem)
{
    QVariantList list;

    // Check if the database connection is open and active
    QSqlDatabase db = QSqlDatabase::database();
    bool dbQuerySuccess = false;

    if (db.isOpen()) {
        QSqlQuery query;
        query.prepare("SELECT name, serial_number, health, temp FROM lru_details WHERE subsystem = :subsystem ORDER BY id ASC");
        query.bindValue(":subsystem", subsystem);

        if (query.exec()) {
            dbQuerySuccess = true;
            while (query.next()) {
                QVariantMap item;
                item["name"] = query.value(0).toString();
                item["serialNumber"] = query.value(1).toString();
                item["health"] = query.value(2).toString();
                item["temp"] = query.value(3).toInt();
                list.append(item);
            }
        } else {
            qWarning() << "Failed to query lru_details:" << query.lastError().text();
        }
    }

    // Fallback if DB query was not successful or returned empty
    if (!dbQuerySuccess || list.isEmpty()) {
        qDebug() << "SQL connection offline or query empty. Loading local fallback LRU details for subsystem:" << subsystem;
        if (subsystem == "TFCS") {
            list << QVariantMap{{"name", "Ballistic Compute Unit"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 34}}
                 << QVariantMap{{"name", "Dual-Channel Comm Link"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 38}}
                 << QVariantMap{{"name", "Direct Fire Link Relay"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 42}};
        } else if (subsystem == "WCS") {
            list << QVariantMap{{"name", "Missile launch C.ontroller"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 34}}
                 << QVariantMap{{"name", "Safe-Arm Board"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 38}}
                 << QVariantMap{{"name", "1Secondary Power Supply Block"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 42}}
                 << QVariantMap{{"name", "2Secory Power Supply Block"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 42}};
        } else if (subsystem == "SIGINT") {
            list << QVariantMap{{"name", "RF Processing Matrix"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 34}}
                 << QVariantMap{{"name", "Spectral Scanning Module"}, {"serialNumber", "SN-84221"}, {"health", "FAULTED"}, {"temp", 52}}
                 << QVariantMap{{"name", "Backup Thermal Shield"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 42}};
        } else if (subsystem == "NAVSUITE") {
            list << QVariantMap{{"name", "Gyroscopic IMU alignment unit"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 34}}
                 << QVariantMap{{"name", "Satellite Triangulation Module"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 35}}
                 << QVariantMap{{"name", "Drift Compensation Board"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 33}};
        } else if (subsystem == "RADAR") {
            list << QVariantMap{{"name", "Active Transmitter Phase Matrix"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 45}}
                 << QVariantMap{{"name", "Sea-Clutter Rejection Unit"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 41}}
                 << QVariantMap{{"name", "Transceiver Array Module"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 49}};
        } else if (subsystem == "UCS") {
            list << QVariantMap{{"name", "Audio/Data Cryptographic Unit"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 38}}
                 << QVariantMap{{"name", "Secure Satellite Datalink Block"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 40}}
                 << QVariantMap{{"name", "Antenna Transceiver Calibrator"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 39}};
        } else if (subsystem == "SA") {
            list << QVariantMap{{"name", "Tactical Situation Computer"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 36}}
                 << QVariantMap{{"name", "Real-Time Track Correlation Unit"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 35}}
                 << QVariantMap{{"name", "Threat Detection Evaluator"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 37}};
        } else {
            // Default generic fallback
            list << QVariantMap{{"name", "Core Compute Block"}, {"serialNumber", "SN-83729"}, {"health", "NOMINAL"}, {"temp", 34}}
                 << QVariantMap{{"name", "Channel Interface Card"}, {"serialNumber", "SN-84221"}, {"health", "NOMINAL"}, {"temp", 38}}
                 << QVariantMap{{"name", "Power Distribution Bus"}, {"serialNumber", "SN-84713"}, {"health", "NOMINAL"}, {"temp", 42}};
        }
    }

    return list;
}

QVariantList ReliabilityController::getAllLogEntries()
{
    QVariantList allLogs;
    for (const QString &sub : m_subsystems) {
        QVariantList subLogs = getLogEntries(sub);
        for (const auto &log : subLogs) {
            allLogs.append(log.toString());
        }
    }
    return allLogs;
}
