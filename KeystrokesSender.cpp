//#include "KeystrokesSender.h"

//namespace
//{
//    constexpr char RETURN_KEY[] = "VK_RETURN";
//}
//QString KeystrokesSender::targetWindowName = "";

//KeystrokesSender::KeystrokesSender(QObject *parent) : QObject(parent), mDevMode(false) { }

//void KeystrokesSender::setupTargetWindow(const QString &target)
//{
//    this->targetWindowName = target;
//}

//void KeystrokesSender::sendMessage(const QString &message)
//{
//    if (message == RETURN_KEY) {
//        sendKey(0x0D);
//        return;
//    }

//    QByteArray ba = message.toUtf8();
//    const auto *thefile = ba.constData();
//    for (int i = 0; thefile[i] != '\0'; ++i) {
//        if ((i > 0) && (thefile[i] == thefile[i - 1])) {
//            Sleep(130); //workaround, there was a problem to send two same chars in a row to certain apps
//        }
//        if ((thefile[i] >= 'A') && (thefile[i] <= 'Z')) {
//            sendKeyUppercase(thefile[i]);
//        } else {
//            sendKey(thefile[i]);
//        }
//    }
//}

//QString KeystrokesSender::text() const
//{
//    return mText;
//}

//void KeystrokesSender::setText(const QString &text)
//{
//    if (text == mText) {
//        return;
//    }
//    mText = text;
//    emit textChanged(mText);
//}

//bool KeystrokesSender::getDevMode() const
//{
//    return mDevMode;
//}

//void KeystrokesSender::setDevMode(bool devMode)
//{
//    if (mDevMode == devMode) {
//        return;
//    }

//    mDevMode = devMode;
//    emit devModeChanged(mDevMode);
//}

//void KeystrokesSender::sendKey(BYTE virtualKey)
//{
//    INPUT Event = {};
//    const SHORT key = VkKeyScan(virtualKey);
//    const UINT mappedKey = MapVirtualKey(LOBYTE(key), 0);
//    Event.type = INPUT_KEYBOARD;
//    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
//    Event.ki.wScan = mappedKey;
//    SendInput(1, &Event, sizeof(Event));
//    Sleep(1);
//}

//void KeystrokesSender::sendKeyUppercase(const BYTE &virtualKey)
//{
//    INPUT Event = {};
//    const SHORT key = VkKeyScan(virtualKey);
//    const UINT mappedKey = MapVirtualKey(LOBYTE(key), 0);

//    //Press shift
//    Event.type = INPUT_KEYBOARD;
//    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
//    Event.ki.wScan = MapVirtualKey(VK_LSHIFT, 0);
//    SendInput(1, &Event, sizeof(Event));

//    // upper case 'virtualKey' (press down)
//    Event.type = INPUT_KEYBOARD;
//    Event.ki.dwFlags = KEYEVENTF_SCANCODE;
//    Event.ki.wScan = mappedKey;
//    SendInput(1, &Event, sizeof(Event));

//    // Release shift key
//    Event.type = INPUT_KEYBOARD;
//    Event.ki.dwFlags = KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP;
//    Event.ki.wScan = MapVirtualKey(VK_LSHIFT, 0);
//    SendInput(1, &Event, sizeof(Event));
//}

//bool CALLBACK KeystrokesSender::EnumWindowsProc(HWND hWnd, long /*lParam*/)
//{
//    char Buff[255];
//    GetWindowTextA(hWnd, Buff, 254);
//    std::string currentWindow(Buff);
//    std::string targetWindow = targetWindowName.toStdString();
//    if (currentWindow.find(targetWindow) != std::string::npos) {
//        targetWindowName = QString::fromStdString(currentWindow);
//    }
//    return true;
//}

//void KeystrokesSender::updateHandler()
//{
//    EnumWindows((WNDENUMPROC)EnumWindowsProc, 0);
//}

//HWND KeystrokesSender::setupHWND()
//{
//    const wchar_t *window = (const wchar_t *)targetWindowName.utf16();
//    HWND hWndTarget = FindWindowW(nullptr, window);
//    return hWndTarget;
//}

//void KeystrokesSender::sendKeystroke(const QStringList &messages)
//{
//    HWND hWndTarget = setupHWND();
//    if (!hWndTarget) {
//        updateHandler();
//        hWndTarget = setupHWND();
//    }

//    if (SetForegroundWindow(hWndTarget)) {
//        if (mDevMode) { sendMessage("`"); }
//        for (const auto &message : messages) {
//            sendMessage(message);
//            sendMessage(RETURN_KEY);
//        }
//        if (mDevMode) { sendMessage("`"); }
//    }
//}

