#include "KeystrokesSender.h"

KeystrokesSender::KeystrokesSender(QObject *parent) : QObject(parent), targetWindow("")
{

}
void KeystrokesSender::setupTargetWindow(const QString &target)
{
    this->targetWindow = target;
}

void KeystrokesSender::sendMessage(QString message)
{
    QMap<QString, int> specialKeys {
        {"VK_BACK_QUOTE", 0xC0},
        {"VK_RETURN", 0x0D},
        {"VK_ESCAPE", 0x1B}
    };

    QMap<QString, int>::Iterator it;
    for (it = specialKeys.begin(); it != specialKeys.end(); ++it) {
        if (message == it.key()) {
            sendKey(it.value());
            return;
        }
    }

    QByteArray ba = message.toUtf8();
    const auto *thefile = ba.constData();
    for (int i = 0; thefile[i] != '\0'; ++i) {
        if ((thefile[i] >= 'A') && (thefile[i] <= 'Z')) {
            sendKeyUppercase(thefile[i]);
        } else {
            sendKey(thefile[i]);
        }
    }
}

void KeystrokesSender::sendKey(BYTE virtualKey)
{
    INPUT Event = {};
    const SHORT key = VkKeyScan(virtualKey);
    const UINT mappedKey = MapVirtualKey(LOBYTE(key), 0);
    Event.type = INPUT_KEYBOARD;
    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
    Event.ki.wScan = mappedKey;
    SendInput(1, &Event, sizeof(Event));

}

void KeystrokesSender::sendKeyUppercase(BYTE virtualKey)
{
    INPUT Event = {};
    const SHORT key = VkKeyScan(virtualKey);
    const UINT mappedKey = MapVirtualKey(LOBYTE(key), 0);

    //Press shift
    Event.type = INPUT_KEYBOARD;
    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
    Event.ki.wScan = MapVirtualKey(VK_LSHIFT, 0);
    SendInput(1, &Event, sizeof(Event));

    // upper case 'virtualKey' (press down)
    Event.type = INPUT_KEYBOARD;
    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
    Event.ki.wScan = mappedKey;
    SendInput(1, &Event, sizeof(Event));

    // Release shift key
    Event.type = INPUT_KEYBOARD;
    Event.ki.dwFlags = KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP;
    Event.ki.wScan = MapVirtualKey(VK_LSHIFT, 0);
    SendInput(1, &Event, sizeof(Event));
}

void KeystrokesSender::sendKeystroke(const QStringList &messages)
{
    const wchar_t *window = (const wchar_t *)targetWindow.utf16();
    HWND hWndTarget = FindWindowW(nullptr, window);
    if (SetForegroundWindow(hWndTarget)) {

        for (const auto &message : messages) {
            sendMessage(message);
        }
    }
}
