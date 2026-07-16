#include "sqlconnection.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QDebug>
#include <QList>

SqlConnection::SqlConnection(QObject *parent) : QObject(parent)
{
}

SqlConnection::~SqlConnection()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

bool SqlConnection::connectToDatabase(const QString &host, int port, const QString &dbName,
                                      const QString &user, const QString &password)
{
    if (QSqlDatabase::contains(QSqlDatabase::defaultConnection)) {
        m_db = QSqlDatabase::database();
    } else {
        if (host.isEmpty()) {
            m_db = QSqlDatabase::addDatabase("QSQLITE");
        } else {
            m_db = QSqlDatabase::addDatabase("QPSQL");
        }
    }

    if (host.isEmpty()) {
        m_db.setDatabaseName(dbName.isEmpty() ? "reliability.db" : dbName);
    } else {
        m_db.setHostName(host);
        m_db.setPort(port);
        m_db.setDatabaseName(dbName);
        m_db.setUserName(user);
        m_db.setPassword(password);
    }

    if (!m_db.open()) {
        qWarning() << "Database Connection Error:" << m_db.lastError().text();
        return false;
    }

    qDebug() << "Database connected successfully to" << m_db.databaseName() << "using driver" << m_db.driverName();
    if (!createUsersTable()) {
        return false;
    }
    return createLruTable();
}

bool SqlConnection::createUsersTable()
{
    QSqlQuery query;
    bool ok = query.exec("CREATE TABLE IF NOT EXISTS users ("
                         "username VARCHAR(50) PRIMARY KEY,"
                         "password_hash VARCHAR(64) NOT NULL"
                         ")");
    if (!ok) {
        qWarning() << "Failed to create table users:" << query.lastError().text();
        return false;
    }

    query.exec("SELECT COUNT(*) FROM users");
    if (query.next() && query.value(0).toInt() == 0) {
        qDebug() << "Table 'users' is empty. Seeding default admin credentials.";
        registerUser("admin", "admin123");
    }

    return true;
}

QString SqlConnection::hashPassword(const QString &password) const
{
    QByteArray hashBytes = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256);
    return QString(hashBytes.toHex());
}

bool SqlConnection::registerUser(const QString &username, const QString &password)
{
    if (!m_db.isOpen()) {
        qWarning() << "Database is not open. Cannot register user.";
        return false;
    }

    QSqlQuery query;
    if (m_db.driverName() == "QSQLITE") {
        query.prepare("INSERT OR IGNORE INTO users (username, password_hash) "
                      "VALUES (:username, :password_hash)");
    } else {
        query.prepare("INSERT INTO users (username, password_hash) "
                      "VALUES (:username, :password_hash) "
                      "ON CONFLICT (username) DO NOTHING");
    }
    query.bindValue(":username", username);
    query.bindValue(":password_hash", hashPassword(password));

    if (!query.exec()) {
        qWarning() << "Register user failed:" << query.lastError().text();
        return false;
    }

    qDebug() << "User registered/verified:" << username;
    return true;
}

bool SqlConnection::verifyUser(const QString &username, const QString &password)
{
    if (!m_db.isOpen()) {
        qWarning() << "Database is not open. Cannot verify user.";
        return false;
    }

    QSqlQuery query;
    query.prepare("SELECT password_hash FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        qWarning() << "Verify user query failed:" << query.lastError().text();
        return false;
    }

    if (query.next()) {
        QString storedHash = query.value(0).toString();
        QString inputHash = hashPassword(password);
        return (storedHash == inputHash);
    }

    return false;
}

bool SqlConnection::createLruTable()
{
    QSqlQuery query;
    QString createQueryStr;
    if (m_db.driverName() == "QSQLITE") {
        createQueryStr = "CREATE TABLE IF NOT EXISTS lru_details ("
                         "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                         "subsystem VARCHAR(50) NOT NULL,"
                         "name VARCHAR(100) NOT NULL,"
                         "serial_number VARCHAR(50) UNIQUE NOT NULL,"
                         "health VARCHAR(50) NOT NULL,"
                         "temp INT NOT NULL"
                         ")";
    } else {
        createQueryStr = "CREATE TABLE IF NOT EXISTS lru_details ("
                         "id SERIAL PRIMARY KEY,"
                         "subsystem VARCHAR(50) NOT NULL,"
                         "name VARCHAR(100) NOT NULL,"
                         "serial_number VARCHAR(50) UNIQUE NOT NULL,"
                         "health VARCHAR(50) NOT NULL,"
                         "temp INT NOT NULL"
                         ")";
    }

    bool ok = query.exec(createQueryStr);
    if (!ok) {
        qWarning() << "Failed to create table lru_details:" << query.lastError().text();
        return false;
    }

    query.exec("SELECT COUNT(*) FROM lru_details");
    if (query.next() && query.value(0).toInt() == 0) {
        qDebug() << "Table 'lru_details' is empty. Seeding initial LRU records.";

        struct LruSeed {
            QString subsystem;
            QString name;
            QString serial_number;
            QString health;
            int temp;
        };

        QList<LruSeed> seeds = {
            // TFCS
            {"TFCS", "Ballis Compute Unit", "SN-83729", "NOMINAL", 34},
            {"TFCS", "Dual-Channel Comm Link", "SN-84221", "NOMINAL", 38},
            {"TFCS", "Direct Fire Link Relay", "SN-84713", "NOMINAL", 42},

            // WCS
            {"WCS", "Missil Launch Controller", "SN-83729", "NOMINAL", 34},
            {"WCS", "Safe-Arm Board", "SN-84221", "NOMINAL", 38},
            {"WCS", "Secondary Power Supply Block", "SN-84713", "NOMINAL", 42},

            // SIGINT
            {"SIGINT", "RF Processing Matrix", "SN-83729", "NOMINAL", 34},
            {"SIGINT", "Spectral Scanning Module", "SN-84221", "FAULTED", 52},
            {"SIGINT", "Backup Thermal Shield", "SN-84713", "NOMINAL", 42},

            // NAVSUITE
            {"NAVSUITE", "Gyroscopic IMU alignment unit", "SN-83729", "NOMINAL", 34},
            {"NAVSUITE", "Satellite Triangulation Module", "SN-84221", "NOMINAL", 35},
            {"NAVSUITE", "Drift Compensation Board", "SN-84713", "NOMINAL", 33},

            // RADAR
            {"RADAR", "Active Transmitter Phase Matrix", "SN-83729", "NOMINAL", 45},
            {"RADAR", "Sea-Clutter Rejection Unit", "SN-84221", "NOMINAL", 41},
            {"RADAR", "Transceiver Array Module", "SN-84713", "NOMINAL", 49},

            // UCS
            {"UCS", "Audio/Data Cryptographic Unit", "SN-83729", "NOMINAL", 38},
            {"UCS", "Secure Satellite Datalink Block", "SN-84221", "NOMINAL", 40},
            {"UCS", "Antenna Transceiver Calibrator", "SN-84713", "NOMINAL", 39},

            // SA
            {"SA", "Tactical Situation Computer", "SN-83729", "NOMINAL", 36},
            {"SA", "Real-Time Track Correlation Unit", "SN-84221", "NOMINAL", 35},
            {"SA", "Threat Detection Evaluator", "SN-84713", "NOMINAL", 37}
        };

        for (const auto &seed : seeds) {
            QSqlQuery insertQuery;
            if (m_db.driverName() == "QSQLITE") {
                insertQuery.prepare("INSERT OR IGNORE INTO lru_details (subsystem, name, serial_number, health, temp) "
                                    "VALUES (:subsystem, :name, :serial_number, :health, :temp)");
            } else {
                insertQuery.prepare("INSERT INTO lru_details (subsystem, name, serial_number, health, temp) "
                                    "VALUES (:subsystem, :name, :serial_number, :health, :temp) "
                                    "ON CONFLICT (serial_number) DO NOTHING");
            }
            insertQuery.bindValue(":subsystem", seed.subsystem);
            insertQuery.bindValue(":name", seed.name);
            insertQuery.bindValue(":serial_number", seed.serial_number);
            insertQuery.bindValue(":health", seed.health);
            insertQuery.bindValue(":temp", seed.temp);
            if (!insertQuery.exec()) {
                qWarning() << "Failed to seed LRU record:" << insertQuery.lastError().text();
            }
        }
    }

    return true;
}
