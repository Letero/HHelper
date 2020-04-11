#include "JsonParser.h"

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
//        todo: throw exception
    }
    const QByteArray ba = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(ba, &err);
    qDebug() << err.errorString();
    qDebug() << err.offset;

    m_config = doc.object();

    if (!m_config.isEmpty())
    {
        m_mainSettings = m_config.value(QString("main_settings")).toObject();
    } else
    {
        return false;
    }
//    saveConfig("config.json");
    return true;
}

bool JsonParser::saveConfig(QString filename)
{
    QFile saveFile(filename);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qDebug() << "file error";
        return false;
//        todo: throw exception
    }
    m_config["main_settings"] = m_mainSettings;
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
    QJsonValue targetWindow = m_mainSettings.value(QString("target_window"));
    m_mainSettings["target_window"] = windowName;
    saveConfig("config.json");
}
