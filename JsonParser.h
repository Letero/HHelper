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
    JsonParser(QObject *parent = nullptr);
    ~JsonParser();
    QString getTargetWindowName();
    void setTargetWindowName(QString windowName);
    void setSlotName(QString slotName);
    QString getSlotName();
    void saveCurrentConfig(ButtonModel *buttonModel);
    QVariantMap getButtonsData();

private:
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonObject m_buttonSettings;
    ButtonModel *buttonModel;
    void writeToFile();
    bool loadConfig(QString filename);
    bool saveConfig(QString filename);
signals:

};
