#pragma once

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QDebug>
#include <QJsonObject>

class JsonParser : public QObject
{
    Q_OBJECT
    QJsonObject settings;
    QJsonObject readFile();
    void writeToFile();
public:
    explicit JsonParser(QObject *parent = nullptr);
    Q_INVOKABLE QString getTargetWindowName();
    Q_INVOKABLE void setTargetWindowName(QString windowName);
signals:

};

