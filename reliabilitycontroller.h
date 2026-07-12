#ifndef RELIABILITYCONTROLLER_H
#define RELIABILITYCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QStringList>

class ReliabilityController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList subsystems READ subsystems CONSTANT)

public:
    explicit ReliabilityController(QObject *parent = nullptr);

    QStringList subsystems() const;

    Q_INVOKABLE QVariantList getHistoryData(const QString &subsystem);
    Q_INVOKABLE QVariantMap getStats(const QString &subsystem);
    Q_INVOKABLE QVariantList getLogEntries(const QString &subsystem);

private:
    QStringList m_subsystems;
};

#endif // RELIABILITYCONTROLLER_H
