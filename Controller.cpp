#include "Controller.h"


Controller::Controller(QObject *parent) : QObject(parent), m_buttonModel(new ButtonModel), configFile("config.json")
{
    m_buttonModel->init(m_jsonParser.getButtonsData());
}

ButtonModel *Controller::getButtonModel() const
{
    return m_buttonModel.get();
}

void Controller::setSlotName(QString name)
{
    m_jsonParser.setSlotName(name);
}

QString Controller::getSlotName() const
{
    return m_jsonParser.getSlotName();
}

void Controller::setHost(const QString& host)
{
    m_jsonParser.setHost(host);
}

QString Controller::getHost() const
{
    return m_jsonParser.getHost();
}

void Controller::saveCurrentConfig()
{
    m_jsonParser.saveConfig(configFile, m_buttonModel.get());
}

bool Controller::isDarkTheme()
{
    return m_jsonParser.isDarkTheme();
}

void Controller::changeTheme(bool isDarkTheme)
{
    m_jsonParser.changeTheme(isDarkTheme);
}

QString Controller::validateSlotName(QString name)
{
    if (!name.startsWith("Slots")) {
        return "Slots" + name;
    }

    return name;
}
