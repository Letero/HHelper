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
        m_mainSettings = m_config.value("main_settings").toObject();
        m_buttonSettings = m_config.value("button_settings").toArray();
        m_commandHistory = m_config.value("command_history").toArray();
        m_hostSettings = m_config.value("host_settings").toArray();
    } else {
        return false;
    }

    return true;
}

bool JsonParser::saveConfig(QString filename, ButtonModel* buttonModel, CommandModel* commandModel, HostModel* hostModel)
{
    QFile saveFile(filename);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qDebug() << "file error";
        return false;
    }
    m_config["main_settings"] = m_mainSettings;

    m_buttonSettings = QJsonArray();
    const auto& buttonData = buttonModel->getButtonDataVector();
    std::transform(buttonData.cbegin(), buttonData.cend(), std::back_inserter(m_buttonSettings), [](const ButtonData& button)
    {
        QJsonArray commands;
        std::copy(button.arguments.cbegin(), button.arguments.cend(), std::back_inserter(commands));
        return QJsonObject({ { "name", button.name }, { "commands", commands } });
    });
    m_config["button_settings"] = m_buttonSettings;

    m_hostSettings = QJsonArray();
    const auto& hostData = hostModel->getHostDataVector();
    std::transform(hostData.cbegin(), hostData.cend(), std::back_inserter(m_hostSettings), [](const auto& host)
    {
        return QJsonObject({ {"name", host.name}, {"address", host.address} });
    });
    m_config["host_settings"] = m_hostSettings;

    m_commandHistory = QJsonArray();
    const auto& commandHistory = commandModel->stringList();
    std::copy(commandHistory.cbegin(), commandHistory.cend(), std::back_inserter(m_commandHistory));
    m_config["command_history"] = m_commandHistory;

    QJsonDocument saveDoc(m_config);
    saveFile.write(saveDoc.toJson());

    return true;
}

QStringList JsonParser::toStringList(const QJsonArray& list)
{
    QStringList string_list;
    std::transform(list.cbegin(), list.cend(), std::back_inserter(string_list), [](const auto& item)
    {
        return item.toString();
    });
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

QString JsonParser::getSlotName() const
{
    QJsonValue slotName = m_mainSettings["slot_name"];
    return slotName.toString();
}

void JsonParser::setHost(const QString &host)
{
    m_mainSettings["host"] = host;
}

QString JsonParser::getHost() const
{
    QJsonValue host = m_mainSettings["host"];
    return host.toString();
}

void JsonParser::setSlotName(QString slotName)
{
    m_mainSettings["slot_name"] = slotName;
}

QVector<ButtonData> JsonParser::getButtonsData()
{
    QVector<ButtonData> data;
    std::transform(m_buttonSettings.cbegin(), m_buttonSettings.cend(), std::back_inserter(data), [](const auto& button)
    {
        QJsonObject buttonObject = button.toObject();
        QStringList commands;
        const auto& commandsArray = buttonObject.take("commands").toArray();
        std::transform(commandsArray.cbegin(), commandsArray.cend(), std::back_inserter(commands), [](const auto& command)
        {
            return command.toString();
        });
        return ButtonData(buttonObject.take("name").toString(), commands);
    });
    return data;
}

QVector<HostData> JsonParser::getHostData()
{
    QVector<HostData> data;
    std::transform(m_hostSettings.cbegin(), m_hostSettings.cend(), std::back_inserter(data), [](const auto& host)
    {
        auto jsonObject = host.toObject();
        return HostData(jsonObject.take("address").toString(), jsonObject.take("name").toString());
    });
    return data;
}

QStringList JsonParser::getCommandHistory()
{
    QStringList history;
    std::transform(m_commandHistory.cbegin(), m_commandHistory.cend(), std::back_inserter(history), [](const auto& command)
    {
        return command.toString();
    });
    return history;
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

