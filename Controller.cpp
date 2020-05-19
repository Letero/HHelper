#include "Controller.h"


Controller::Controller(QObject *parent) : QObject(parent), m_buttonModel(new ButtonModel), configFile("config.json")
{
    m_buttonModel->init(m_jsonParser.getButtonsData());
}

ButtonModel *Controller::getButtonModel() const
{
    return m_buttonModel.get();
}

QString Controller::getTargetWindow()
{
    return m_jsonParser.getTargetWindowName();
}

void Controller::setTargetWindow(QString name)
{
    m_jsonParser.setTargetWindowName(name);
}

void Controller::setSlotName(QString name)
{
    m_jsonParser.setSlotName(name);
}

QString Controller::getSlotName()
{
    return m_jsonParser.getSlotName();
}

void Controller::saveCurrentConfig()
{
    m_jsonParser.saveConfig(configFile, m_buttonModel.get());
}

bool Controller::isDevMode()
{
    return m_jsonParser.isDevMode();
}

void Controller::changeDevMode(bool isDevMode)
{
    m_jsonParser.changeDevMode(isDevMode);
}

QString Controller::validateSlotName(QString name)
{
    if (!name.startsWith("Slots")) {
        return "Slots" + name;
    }

    return name;
}
