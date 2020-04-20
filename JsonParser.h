#pragma once

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QDebug>
#include <QJsonObject>
#include <QMap>
#include "ButtonModel.h"

class JsonParser : public QObject
{
    Q_OBJECT
public:
    JsonParser(QObject *parent = nullptr, ButtonModel *btnObj = nullptr);
    ~JsonParser();
    Q_INVOKABLE QString getTargetWindowName();
    Q_INVOKABLE void setTargetWindowName(QString windowName);
    Q_INVOKABLE void setSlotName(QString slotName);
    Q_INVOKABLE QString getSlotName();
    Q_INVOKABLE void saveCurrentConfig();
    Q_INVOKABLE QVariantMap getButtonsData();
private:
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonObject m_buttonSettings;
    ButtonModel *buttonModelptr;
    void writeToFile();
    bool loadConfig(QString filename);
    bool saveConfig(QString filename);
signals:

};
