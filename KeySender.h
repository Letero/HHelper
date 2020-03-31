#pragma once

#include <QObject>
#include <QDebug>
#include <Windows.h>
//#include <WinUser.h>

class KeystrokesSender : public QObject
{
    Q_OBJECT
private:
    void SendKey(BYTE virtualKey);
    void SendKeyUppercase(BYTE virtualKey);
    void SendMessage(QString message);
public:
    explicit KeystrokesSender(QObject *parent = nullptr);

    Q_INVOKABLE void sendKeystroke( const QString &message);

signals:

};

