#include "JsonParser.h"
#include "QJsonArray"

JsonParser::JsonParser(QObject *parent) : QObject(parent)
{
    loadConfig("config.json");
}

bool JsonParser::loadConfig(QString filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "file error";
        return false;
    }
    const QByteArray ba = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(ba, &err);
    qDebug() << err.errorString();
    qDebug() << err.offset;

    m_config = doc.object();

    if (!m_config.isEmpty()) {
        m_mainSettings = m_config.value(QString("main_settings")).toObject();
        m_buttonSettings = m_config.value(QString("button_settings")).toObject();
    } else {
        return false;
    }

    return true;
}

bool JsonParser::saveConfig(QString filename)
{
    QFile saveFile(filename);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qDebug() << "file error";
        return false;
    }
    m_config["main_settings"] = m_mainSettings;
    m_config["button_settings"] = m_buttonSettings;
    QJsonDocument saveDoc(m_config);
    saveFile.write(saveDoc.toJson());

    return true;
}

QString JsonParser::getTargetWindowName()
{
    QJsonValue targetWindow = m_mainSettings.value(QString("target_window"));
    return targetWindow.toString();
}

void JsonParser::setTargetWindowName(QString windowName)
{
    m_mainSettings["target_window"] = windowName;
}

QString JsonParser::getSlotName()
{
    QJsonValue slotName = m_mainSettings.value(QString("slot_name"));
    return slotName.toString();
}

void JsonParser::setSlotName(QString slotName)
{
    m_mainSettings["slot_name"] = slotName;
}

void JsonParser::saveCurrentConfig()
{
    saveConfig("config.json");
}

QVariantMap JsonParser::getButtonsData()
{
    QVariantMap data;
    for (auto key : m_buttonSettings.keys()) {
        data[key] = {m_buttonSettings[key]};
    }
    return data;
}

void JsonParser::addButton(QString name, const QJsonArray &args)
{
    m_buttonSettings[name] = args;
}
