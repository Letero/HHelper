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

bool JsonParser::saveConfig(QString filename, ButtonModel *buttonModel)
{
    QFile saveFile(filename);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qDebug() << "file error";
        return false;
    }
    m_config["main_settings"] = m_mainSettings;
    m_buttonSettings = QJsonObject();
    for (auto info : buttonModel->getButtonDataVector()) {
        QJsonArray temp;
        for (auto arg : info.arguments) {
            temp.push_back(arg);
        }
        m_buttonSettings[info.name] = temp;
    }

    m_config["button_settings"] = m_buttonSettings;
    QJsonDocument saveDoc(m_config);
    saveFile.write(saveDoc.toJson());

    return true;
}

QStringList JsonParser::toStringList(const QJsonArray &list)
{
    QStringList string_list;
    for (auto sr : list) {
        string_list.append(sr.toString());
    }
    return string_list;
}

QString JsonParser::getTargetWindowName()
{
    QJsonValue targetWindow = m_mainSettings["target_window"];
    return targetWindow.toString();
}

void JsonParser::setTargetWindowName(QString windowName)
{
    m_mainSettings["target_window"] = windowName;
}

QString JsonParser::getSlotName()
{
    QJsonValue slotName = m_mainSettings["slot_name"];
    return slotName.toString();
}

void JsonParser::setHost(const QString& host)
{
    m_mainSettings["host"] = host;
}

QString JsonParser::getHost()
{
    QJsonValue host = m_mainSettings["host"];
    return host.toString();
}

void JsonParser::setSlotName(QString slotName)
{
    m_mainSettings["slot_name"] = slotName;
}

QMap<QString, QStringList> JsonParser::getButtonsData()
{
    QMap<QString, QStringList> data;
    for (auto key : m_buttonSettings.keys()) {
        data[key] = toStringList(m_buttonSettings[key].toArray());
    }
    return data;
}

bool JsonParser::isDevMode()
{
    if (m_mainSettings["dev_mode"] == 1) {
        return true;
    }
    return false;
}

void JsonParser::changeDevMode(bool isDevMode)
{
    if (isDevMode) {
        m_mainSettings["dev_mode"] = 1;
    } else {
        m_mainSettings["dev_mode"] = 0;
    }
}

bool JsonParser::isDarkTheme()
{
    if (m_mainSettings["dark_theme"] == 1) {
        return true;
    }
    return false;
}

void JsonParser::changeTheme(bool isDarkTheme)
{
    if (isDarkTheme) {
        m_mainSettings["dark_theme"] = 1;
    } else {
        m_mainSettings["dark_theme"] = 0;
    }
}

