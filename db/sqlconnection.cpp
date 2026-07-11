#include "sqlconnection.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QDebug>

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
        m_db = QSqlDatabase::addDatabase("QPSQL");
    }

    m_db.setHostName(host);
    m_db.setPort(port);
    m_db.setDatabaseName(dbName);
    m_db.setUserName(user);
    m_db.setPassword(password);

    if (!m_db.open()) {
        qWarning() << "Database Connection Error:" << m_db.lastError().text();
        return false;
    }

    qDebug() << "Database connected successfully to" << dbName;
    return createUsersTable();
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
    query.prepare("INSERT INTO users (username, password_hash) "
                  "VALUES (:username, :password_hash) "
                  "ON CONFLICT (username) DO NOTHING");
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
