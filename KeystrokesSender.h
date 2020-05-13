#pragma once

#include <QObject>
#include <QDebug>
#include <Windows.h>
//#include <WinUser.h>

class KeystrokesSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
private:
    QString mText;
    QString targetWindow;
    void sendKey(BYTE virtualKey);
    void sendKeyUppercase(const BYTE &virtualKey);
    void sendMessage(const QString &message);

public:
    QString text() const
    {
        return mText;
    }
    void setText(const QString &text)
    {
        if (text == mText) {
            return;
        }
        mText = text;
        emit textChanged(mText);
    }
    explicit KeystrokesSender(QObject *parent = nullptr);
    Q_INVOKABLE void setupTargetWindow(const QString &target);
    Q_INVOKABLE void sendKeystroke(const QStringList &messages);

signals:
    void textChanged(const QString &text);
};

