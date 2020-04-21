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
    QString getTargetWindowName();
    void setTargetWindowName(QString windowName);
    void setSlotName(QString slotName);
    QString getSlotName();
    bool saveConfig(QString filename, ButtonModel *buttonModel);
    QMap<QString, QStringList> getButtonsData();
private:
    QJsonObject m_config;
    QJsonObject m_mainSettings;
    QJsonObject m_buttonSettings;
    void writeToFile();
    bool loadConfig(QString filename);
    QStringList toStringList(const QJsonArray &list);
signals:

};
