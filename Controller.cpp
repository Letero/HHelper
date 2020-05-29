#include "Controller.h"

Controller::Controller(QObject *parent)
    : QObject(parent)
    , m_buttonModel(new ButtonModel)
    , m_commandModel(new CommandModel)
    , m_hostModel(new HostModel)
{
    m_buttonModel->init(m_jsonParser.getButtonsData());
    m_commandModel->init(m_jsonParser.getCommandHistory());
    m_hostModel->init(m_jsonParser.getHostData());
}

ButtonModel *Controller::getButtonModel() const
{
    return m_buttonModel.get();
}

CommandModel *Controller::getCommandModel() const
{
    return m_commandModel.get();
}

HostModel *Controller::getHostModel() const
{
    return m_hostModel.get();
}

void Controller::setSlotName(QString name)
{
    m_jsonParser.setSlotName(name);
}

QString Controller::getSlotName() const
{
    return m_jsonParser.getSlotName();
}

void Controller::setHost(const QString &host)
{
    m_jsonParser.setHost(host);
}

QString Controller::getHost() const
{
    return m_jsonParser.getHost();
}

void Controller::saveCurrentConfig()
{
    m_jsonParser.saveConfig(m_buttonModel.get(), m_commandModel.get(), m_hostModel.get());
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

int Controller::getWidth() const { return m_jsonParser.getWidth(); }

int Controller::getHeight() const { return m_jsonParser.getHeight(); }

void Controller::setHeight(const int &height) { m_jsonParser.setHeight(height); }

void Controller::setWidth(const int &width) { m_jsonParser.setWidth(width); }


