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
    ButtonModel *getButtonModel() const;
    Q_INVOKABLE QString getTargetWindow();
    Q_INVOKABLE void setTargetWindow(QString name);
    Q_INVOKABLE void setSlotName(QString name);
    Q_INVOKABLE QString getSlotName();
    Q_INVOKABLE void saveCurrentConfig();

private:
    QScopedPointer<ButtonModel> m_buttonModel;
    JsonParser m_jsonParser;
    QString configFile;
};

