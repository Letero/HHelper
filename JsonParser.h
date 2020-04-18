#pragma once

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QDebug>
#include <QJsonObject>
#include <QMap>

class JsonParser : public QObject
{
    Q_OBJECT
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonObject m_buttonSettings;
    void writeToFile();
    bool loadConfig(QString filename);
    bool saveConfig(QString filename);
public:
    explicit JsonParser(QObject *parent = nullptr);
    Q_INVOKABLE QString getTargetWindowName();
    Q_INVOKABLE void setTargetWindowName(QString windowName);
    Q_INVOKABLE void setSlotName(QString slotName);
    Q_INVOKABLE QString getSlotName();
    Q_INVOKABLE void saveCurrentConfig();
    Q_INVOKABLE QVariantMap getButtonsData();
    Q_INVOKABLE void addButton(QString name, const QJsonArray &args);
    Q_INVOKABLE void removeButton(QString name);
signals:

};
