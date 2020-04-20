#pragma once

#include <QObject>
#include "ButtonModel.h"
#include "JsonParser.h"

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ButtonModel *buttonModel READ getButtonModel CONSTANT)
public:
    Controller(QObject *parent = nullptr);
    Q_INVOKABLE void init();
    ButtonModel *getButtonModel() const;
    Q_INVOKABLE QString getTargetWindow();
    Q_INVOKABLE void setTargetWindow(QString name);
    Q_INVOKABLE void saveCurrentConfig();
    Q_INVOKABLE void setSlotName(QString name);
    Q_INVOKABLE QString getSlotName();

private:
    QScopedPointer<ButtonModel> m_buttonModel;
    JsonParser m_jsonParser;
};

