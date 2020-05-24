#pragma once

#include "ButtonModel.h"
#include "HostModel.h"

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMap>
#include <QJsonArray>
#include <algorithm>

class JsonParser : public QObject
{
    Q_OBJECT
public:
    JsonParser(QObject *parent = nullptr);
    QString getTargetWindowName();
    void setTargetWindowName(QString windowName);
    void setSlotName(QString slotName);
    QString getSlotName() const;
    void setHost(const QString& host);
    QString getHost() const;
    bool saveConfig(QString filename, ButtonModel* buttonModel, HostModel* hostModel);
    QMap<QString, QStringList> getButtonsData();
    QVector<HostData> getHostData();
    bool isDevMode();
    void changeDevMode(bool isDevMode);
    bool isDarkTheme();
    void changeTheme(bool isDarkTheme);
private:
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonObject m_buttonSettings;
    QJsonArray m_hostSettings;
    void writeToFile();
    bool loadConfig(QString filename);
    QStringList toStringList(const QJsonArray &list);

};
