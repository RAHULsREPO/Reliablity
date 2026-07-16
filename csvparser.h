#ifndef CSVPARSER_H
#define CSVPARSER_H

#include <QObject>
#include <QVariantList>
#include <QStringList>
#include <QString>

class CsvParser : public QObject
{
    Q_OBJECT

public:
    explicit CsvParser(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList parseCsv(const QString &filePath);

private:
    QStringList splitCsvLine(const QString &line);
};

#endif // CSVPARSER_H
