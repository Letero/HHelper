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
    Q_INVOKABLE void setSlotName(QString name);
    Q_INVOKABLE QString getSlotName() const;
    Q_INVOKABLE void setHost(const QString& host);
    Q_INVOKABLE QString getHost() const;
    Q_INVOKABLE void saveCurrentConfig();
    Q_INVOKABLE bool isDarkTheme();
    Q_INVOKABLE void changeTheme(bool isDarkTheme);
    Q_INVOKABLE QString validateSlotName(QString name);

private:
    QScopedPointer<ButtonModel> m_buttonModel;
    JsonParser m_jsonParser;
    QString configFile;
};

