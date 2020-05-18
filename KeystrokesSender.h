#pragma once

#include <QObject>
#include <QDebug>
#include <Windows.h>
//#include <WinUser.h>

class KeystrokesSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(bool devMode READ getDevMode WRITE setDevMode NOTIFY devModeChanged)
public:
    QString text() const;
    void setText(const QString &text);
    bool getDevMode() const;
    void setDevMode(bool devMode);
    explicit KeystrokesSender(QObject *parent = nullptr);
    Q_INVOKABLE void setupTargetWindow(const QString &target);
    Q_INVOKABLE void sendKeystroke(const QStringList &messages);
signals:
    void textChanged(const QString &text);
    void devModeChanged(bool devMode);
private:
    QString mText;
    bool wasModified;
    static QString targetWindowName;
    static HWND targetWindowHandler;
    void sendKey(BYTE virtualKey);
    void sendKeyUppercase(const BYTE &virtualKey);
    bool CALLBACK static EnumWindowsProc(HWND hWnd, long lParam);
    void updateHandler();
    void sendMessage(const QString &message);
    bool mDevMode;
};

