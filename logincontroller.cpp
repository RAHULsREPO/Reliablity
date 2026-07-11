#include "logincontroller.h"
#include <QDebug>

LoginController::LoginController(QObject *parent)
    : QObject(parent), m_db(new SqlConnection(this))
{
    // Try to connect to PostgreSQL with default credentials
    bool connected = m_db->connectToDatabase("localhost", 5432, "security_db", "postgres", "postgres123");
    if (!connected) {
        qWarning() << "Failed to connect to PostgreSQL database. Offline fallback activated.";
    }
}

void LoginController::login(const QString &username, const QString &password)
{
    if (username.isEmpty() || password.isEmpty()) {
        emit loginResult(false, "Username and password fields cannot be empty.");
        return;
    }

    // First attempt authentication through PostgreSQL database
    bool success = m_db->verifyUser(username, password);
    if (success) {
        emit loginResult(true, "Authentication successful! Welcome to the Admin secure dashboard (DB-verified).");
        return;
    }

    // If verification failed but DB was unavailable or credentials mismatch,
    // we fallback to local offline credentials check to allow testing the UI.
    if (username == "admin" && password == "admin123") {
        emit loginResult(true, "Authentication successful! Welcome to the Admin secure dashboard (Offline Fallback).");
    } else {
        emit loginResult(false, "Access denied. Invalid credentials. Please verify your security key.");
    }
}
