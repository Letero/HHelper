#pragma once

#include "ButtonModel.h"
#include "CommandModel.h"
#include "HostModel.h"

#include <QJsonObject>
#include <QJsonArray>

class JsonParser : public QObject
{
    Q_OBJECT
public:
    JsonParser(QObject *parent = nullptr);
    void setSlotName(QString slotName);
    QString getSlotName() const;
    void setHost(const QString &host);
    QString getHost() const;
    bool saveConfig(ButtonModel* buttonModel, CommandModel* commandModel, HostModel* hostModel);
    QVector<ButtonData> getButtonsData();
    QVector<HostData> getHostData();
    QStringList getCommandHistory();
    bool isDarkTheme();
    void changeTheme(bool isDarkTheme);
private:
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonArray m_buttonSettings;
    QJsonArray m_commandHistory;
    QJsonArray m_hostSettings;
    void writeToFile();
    bool loadConfig(QString filename);
    QStringList toStringList(const QJsonArray& list);

};
