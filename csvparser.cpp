#include "csvparser.h"
#include <QFile>
#include <QTextStream>
#include <QVariantMap>
#include <QDebug>

CsvParser::CsvParser(QObject *parent) : QObject(parent)
{
}

QStringList CsvParser::splitCsvLine(const QString &line)
{
    QStringList fields;
    QString field;
    bool inQuotes = false;
    for (int i = 0; i < line.length(); ++i) {
        QChar c = line[i];
        if (c == '"') {
            inQuotes = !inQuotes;
        } else if (c == ',' && !inQuotes) {
            fields.append(field.trimmed());
            field.clear();
        } else {
            field.append(c);
        }
    }
    fields.append(field.trimmed());
    return fields;
}

QVariantList CsvParser::parseCsv(const QString &filePath)
{
    QVariantList records;
    
    // Normalize path (handle QML file scheme prefixes)
    QString cleanPath = filePath;
    if (cleanPath.startsWith("file:///")) {
#ifdef Q_OS_WIN
        cleanPath = cleanPath.mid(8);
#else
        cleanPath = cleanPath.mid(7);
#endif
    } else if (cleanPath.startsWith("file://")) {
        cleanPath = cleanPath.mid(7);
    }

    QFile file(cleanPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "CsvParser: Failed to open CSV file:" << cleanPath;
        return records;
    }

    QTextStream in(&file);
    if (in.atEnd()) {
        file.close();
        return records;
    }

    // Read header line to identify columns
    QString headerLine = in.readLine();
    QStringList headers = splitCsvLine(headerLine);
    
    int ssbCodeIndex = -1;
    int nameIndex = -1;
    
    for (int i = 0; i < headers.size(); ++i) {
        QString header = headers[i].trimmed().toLower();
        if (header.startsWith('"') && header.endsWith('"')) {
            header = header.mid(1, header.length() - 2);
        }
        header = header.trimmed();
        if (header == "ssb_code" || header == "ssbcode" || header == "ssb_codes") {
            ssbCodeIndex = i;
        } else if (header == "name" || header == "component_name" || header == "componentname") {
            nameIndex = i;
        }
    }

    // Fallback if ssb_code or name header is not found
    if (ssbCodeIndex == -1) ssbCodeIndex = 0;
    if (nameIndex == -1) nameIndex = 1;

    qDebug() << "CsvParser: Parsing columns - ssb_code index:" << ssbCodeIndex << ", name index:" << nameIndex;

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue;

        QStringList fields = splitCsvLine(line);
        if (fields.size() <= qMax(ssbCodeIndex, nameIndex)) {
            continue; // Skip malformed rows
        }

        QString ssbCode = fields[ssbCodeIndex];
        QString name = fields[nameIndex];

        // Strip quotes if they enclose the fields
        if (ssbCode.startsWith('"') && ssbCode.endsWith('"')) {
            ssbCode = ssbCode.mid(1, ssbCode.length() - 2);
        }
        if (name.startsWith('"') && name.endsWith('"')) {
            name = name.mid(1, name.length() - 2);
        }

        ssbCode = ssbCode.trimmed();
        name = name.trimmed();

        QVariantMap record;
        record["ssb_code"] = ssbCode;
        record["name"] = name;
        records.append(record);
    }

    file.close();
    qDebug() << "CsvParser: Successfully parsed" << records.size() << "records.";
    return records;
}
