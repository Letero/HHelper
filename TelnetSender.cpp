#include "TelnetSender.h"

#include <QDir>
#include <QRegExp>
namespace
{
    constexpr auto DEFAULT_HOST = "localhost";
    constexpr auto DEFAULT_PORT = 1337;
    constexpr auto LOGS_PATH = "logs";
    constexpr auto LOG_FILE_NAME_TEMPLATE = "logs(%1).txt";
}

TelnetSender::TelnetSender(QObject *parent) : QObject(parent)
{
    connect(&tcpSocket, &QTcpSocket::stateChanged, this, &TelnetSender::connectedChanged);
    connect(&tcpSocket, &QTcpSocket::stateChanged, this, &TelnetSender::tryCreateFile);
    connect(&tcpSocket, &QTcpSocket::readyRead, this, &TelnetSender::logToFile);
    connect(this, &TelnetSender::hostChanged, this, &TelnetSender::connectToTelnet);
}

bool TelnetSender::connected() const
{
    return tcpSocket.state() == QTcpSocket::ConnectedState;
}

void TelnetSender::send(const QStringList &messages)
{
    for (const auto& message : messages) {
        tcpSocket.write(qPrintable(message + "\n"));
    }
}

void TelnetSender::setHost(const QString &host)
{
    if (m_host == host) {
        return;
    }

    m_host = host;
    m_hostGotChanged = true;
    m_logFile.close();
    emit hostChanged();
}

void TelnetSender::connectToTelnet()
{
    tcpSocket.abort();
    if (m_host.endsWith(':'))
        return;

    QRegExp reg("(.*):(.*)");
    reg.exactMatch(m_host);
    auto hostAddress = reg.exactMatch(m_host) ? reg.cap(1) : m_host;
    const auto portString = reg.cap(2);

    hostAddress = !hostAddress.isEmpty() ? hostAddress : DEFAULT_HOST;
    const auto port = !portString.isEmpty() ? portString.toInt() : DEFAULT_PORT;
    tcpSocket.connectToHost(hostAddress, port, QTcpSocket::ReadWrite);
}

void TelnetSender::logToFile()
{
    if (m_logFile.isWritable())
    {
        const auto data = tcpSocket.readAll();
        if (data.size() > 2)
        {
            m_logFile.write(data);
            m_logFile.flush();
        }
    }
}

void TelnetSender::tryCreateFile()
{
    if (!connected() || !m_hostGotChanged)
        return;

    m_hostGotChanged = false;

    if (!QDir(LOGS_PATH).exists())
    {
        QDir().mkdir(LOGS_PATH);
    }
    auto hostAddress = !m_host.isEmpty() ? m_host : DEFAULT_HOST;
    const auto fileName = QString(LOGS_PATH) + "/" + QString(LOG_FILE_NAME_TEMPLATE).arg(hostAddress.replace(':', '-'));
    m_logFile.setFileName(fileName);
    m_logFile.open(QIODevice::WriteOnly);
}
