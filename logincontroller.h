#ifndef LOGINCONTROLLER_H
#define LOGINCONTROLLER_H

#include <QObject>
#include <QString>
#include "db/sqlconnection.h"

class LoginController : public QObject
{
    Q_OBJECT

public:
    explicit LoginController(QObject *parent = nullptr);

    Q_INVOKABLE void login(const QString &username, const QString &password);

signals:
    void loginResult(bool success, const QString &message);

private:
    SqlConnection *m_db;
};

#endif // LOGINCONTROLLER_H
