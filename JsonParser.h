#pragma once

#include <QObject>
#include <QFile>
#include <QDebug>
#include <QJsonDocument>
#include <QDebug>
#include <QJsonObject>
#include <QMap>
#include <QJsonArray>

#include <algorithm>

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
    QMap<QString, QStringList> getButtonsData1()
    {
        QMap<QString, QStringList> data;
        for (auto key : m_buttonSettings.keys()) {
            for (auto dupeczka : m_buttonSettings[key].toArray()) {
                data[key].append(dupeczka.toString());
            }
        }
        return data;
    }

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
