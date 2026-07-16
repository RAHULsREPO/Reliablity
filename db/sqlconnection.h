#ifndef SQLCONNECTION_H
#define SQLCONNECTION_H

#include <QObject>
#include <QSqlDatabase>
#include <QString>

class SqlConnection : public QObject
{
    Q_OBJECT

public:
    explicit SqlConnection(QObject *parent = nullptr);
    ~SqlConnection();

    bool connectToDatabase(const QString &host, int port, const QString &dbName,
                            const QString &user, const QString &password);
    bool verifyUser(const QString &username, const QString &password);
    bool registerUser(const QString &username, const QString &password);

private:
    QSqlDatabase m_db;
    bool createUsersTable();
    bool createLruTable();
    QString hashPassword(const QString &password) const;
};

#endif // SQLCONNECTION_H
