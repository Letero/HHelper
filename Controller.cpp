#include "Controller.h"


Controller::Controller(QObject *parent) : QObject(parent), m_buttonModel(new ButtonModel)
{

}

void Controller::init()
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
