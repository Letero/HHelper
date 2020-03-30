#include "KeySender.h"

KeystrokesSender::KeystrokesSender(QObject *parent) : QObject(parent)
{

}

void KeystrokesSender::SendMessage(QString message)
{
    QMap<QString, int> specialKeys
    {
        {"VK_BACK_QUOTE", 0xC0},
        {"VK_RETURN", 0x0D}
    };

    QMap<QString, int>::Iterator it;
    for (it = specialKeys.begin(); it != specialKeys.end(); ++it)
    {
        if (message == it.key())
        {
            SendKey(it.value());
            return;
        }
    }

    QByteArray ba = message.toUtf8();
    const char *thefile = ba.constData();

    while (thefile--)
    {
        qDebug() <<"";
    }

}

void KeystrokesSender::SendKey(BYTE virtualKey)
{
    keybd_event(virtualKey, 0, 0, 0);
    keybd_event(virtualKey, 0, KEYEVENTF_KEYUP, 0);
}

void KeystrokesSender::sendKeystroke(const QString &message)
{
    HWND hWndTarget = FindWindowW(nullptr, L"*Untitled - Notepad");
    if (SetForegroundWindow(hWndTarget))
    {
        SendMessage(message);
    }
}
