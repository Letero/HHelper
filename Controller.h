#pragma once

#include "ButtonModel.h"
#include "CommandModel.h"
#include "HostModel.h"
#include "JsonParser.h"

#include <QObject>

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ButtonModel *buttonModel READ getButtonModel CONSTANT)
    Q_PROPERTY(CommandModel *commandModel READ getCommandModel CONSTANT)
    Q_PROPERTY(HostModel *hostModel READ getHostModel CONSTANT)

public:
    Controller(QObject *parent = nullptr);
    ButtonModel *getButtonModel() const;
    CommandModel *getCommandModel() const;
    HostModel *getHostModel() const;
    Q_INVOKABLE void setSlotName(QString name);
    Q_INVOKABLE QString getSlotName() const;
    Q_INVOKABLE void setHost(const QString &host);
    Q_INVOKABLE QString getHost() const;
    Q_INVOKABLE void saveCurrentConfig();
    Q_INVOKABLE bool isDarkTheme();
    Q_INVOKABLE void changeTheme(bool isDarkTheme);
    Q_INVOKABLE QString validateSlotName(QString name);
    Q_INVOKABLE int getHeight() const;
    Q_INVOKABLE int getWidth() const;
    Q_INVOKABLE void setHeight(const int &height);
    Q_INVOKABLE void setWidth(const int &width);
    Q_INVOKABLE void openExternal(const QString& path);

private:
    QScopedPointer<ButtonModel> m_buttonModel;
    QScopedPointer<CommandModel> m_commandModel;
    QScopedPointer<HostModel> m_hostModel;
    JsonParser m_jsonParser;
};

