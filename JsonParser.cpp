#include "JsonParser.h"

#include <QDebug>
#include <QFile>
#include <QJsonDocument>

#include <algorithm>

namespace
{
    const auto CONFIG_FILE = "config.json";

    const auto SETTINGS_NODE = "main_settings";
    const auto SLOT_NAME_NODE = "slot_name";
    const auto HOST_NODE = "host";
    const auto DARK_THEME_NODE = "dark_theme";
    const auto HEIGHT_NODE = "height";
    const auto WIDTH_NODE = "width";

    const auto BUTTONS_NODE = "button_settings";
    const auto BUTTON_NAME_NODE = "name";
    const auto BUTTON_COMMANDS_NODE = "commands";

    const auto HOSTS_NODE = "host_settings";
    const auto HOST_NAME_NODE = "name";
    const auto HOST_ADDRESS_NODE = "address";

    const auto COMMAND_HISTORY_NODE = "command_history";
}

JsonParser::JsonParser(QObject *parent) : QObject(parent)
{
    loadConfig(CONFIG_FILE);
}

bool JsonParser::loadConfig(QString filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << file.errorString();
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
        m_mainSettings = m_config.value(SETTINGS_NODE).toObject();
        m_buttonSettings = m_config.value(BUTTONS_NODE).toArray();
        m_commandHistory = m_config.value(COMMAND_HISTORY_NODE).toArray();
        m_hostSettings = m_config.value(HOSTS_NODE).toArray();
    } else {
        return false;
    }

    return true;
}

bool JsonParser::saveConfig(ButtonModel *buttonModel, CommandModel *commandModel, HostModel *hostModel)
{
    QFile saveFile(CONFIG_FILE);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qDebug() << saveFile.errorString();
        return false;
    }
    m_config[SETTINGS_NODE] = m_mainSettings;

    m_buttonSettings = QJsonArray();
    const auto &buttonData = buttonModel->getButtonDataVector();
    std::transform(buttonData.cbegin(), buttonData.cend(),
    std::back_inserter(m_buttonSettings), [](const ButtonData & button) {
        QJsonArray commands;
        std::copy(button.arguments.cbegin(), button.arguments.cend(), std::back_inserter(commands));
        return QJsonObject({ { BUTTON_NAME_NODE, button.name }, { BUTTON_COMMANDS_NODE, commands } });
    });
    m_config[BUTTONS_NODE] = m_buttonSettings;

    m_hostSettings = QJsonArray();
    const auto &hostData = hostModel->getHostDataVector();
    std::transform(hostData.cbegin(), hostData.cend(), std::back_inserter(m_hostSettings), [](const auto & host) {
        return QJsonObject({ {HOST_NAME_NODE, host.name}, {HOST_ADDRESS_NODE, host.address} });
    });
    m_config[HOSTS_NODE] = m_hostSettings;

    m_commandHistory = QJsonArray();
    const auto &commandHistory = commandModel->stringList();
    std::copy(commandHistory.cbegin(), commandHistory.cend(), std::back_inserter(m_commandHistory));
    m_config[COMMAND_HISTORY_NODE] = m_commandHistory;

    QJsonDocument saveDoc(m_config);
    saveFile.write(saveDoc.toJson());

    return true;
}

QStringList JsonParser::toStringList(const QJsonArray &list)
{
    QStringList string_list;
    std::transform(list.cbegin(), list.cend(), std::back_inserter(string_list), [](const auto & item) {
        return item.toString();
    });
    return string_list;
}

QString JsonParser::getSlotName() const
{
    return m_mainSettings[SLOT_NAME_NODE].toString();
}

void JsonParser::setHost(const QString &host)
{
    m_mainSettings[HOST_NODE] = host;
}

QString JsonParser::getHost() const
{
    return m_mainSettings[HOST_NODE].toString();
}

void JsonParser::setSlotName(QString slotName)
{
    m_mainSettings[SLOT_NAME_NODE] = slotName;
}

QVector<ButtonData> JsonParser::getButtonsData()
{
    QVector<ButtonData> data;
    std::transform(m_buttonSettings.cbegin(), m_buttonSettings.cend(), std::back_inserter(data), [](const auto & button) {
        QJsonObject buttonObject = button.toObject();
        QStringList commands;
        const auto &commandsArray = buttonObject.take(BUTTON_COMMANDS_NODE).toArray();
        std::transform(commandsArray.cbegin(), commandsArray.cend(), std::back_inserter(commands), [](const auto & command) {
            return command.toString();
        });
        return ButtonData(buttonObject.take(BUTTON_NAME_NODE).toString(), commands);
    });
    return data;
}

QVector<HostData> JsonParser::getHostData()
{
    QVector<HostData> data;
    std::transform(m_hostSettings.cbegin(), m_hostSettings.cend(), std::back_inserter(data), [](const auto & host) {
        auto jsonObject = host.toObject();
        return HostData(jsonObject.take(HOST_ADDRESS_NODE).toString(), jsonObject.take(HOST_NAME_NODE).toString());
    });
    return data;
}

QStringList JsonParser::getCommandHistory()
{
    QStringList history;
    std::transform(m_commandHistory.cbegin(), m_commandHistory.cend(),
    std::back_inserter(history), [](const auto & command) {
        return command.toString();
    });
    return history;
}

bool JsonParser::isDarkTheme()
{
    if (m_mainSettings[DARK_THEME_NODE] == 1) {
        return true;
    }
    return false;
}

void JsonParser::changeTheme(bool isDarkTheme)
{
    if (isDarkTheme) {
        m_mainSettings[DARK_THEME_NODE] = 1;
    } else {
        m_mainSettings[DARK_THEME_NODE] = 0;
    }
}

int JsonParser::getWidth() const
{
    return m_mainSettings[WIDTH_NODE].toInt();
}

int JsonParser::getHeight() const
{
    return m_mainSettings[HEIGHT_NODE].toInt();
}

void JsonParser::setHeight(const int &height)
{
    m_mainSettings[HEIGHT_NODE] = height;
}

void JsonParser::setWidth(const int &width)
{
    m_mainSettings[WIDTH_NODE] = width;
}

