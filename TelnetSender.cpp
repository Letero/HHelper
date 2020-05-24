#include "TelnetSender.h"

namespace
{
    constexpr auto PORT = 1337;
    constexpr auto DEFAULT_HOST = "localhost";
}

TelnetSender::TelnetSender(QObject *parent) : QObject(parent)
{
    connect(&tcpSocket, &QTcpSocket::stateChanged, this, &TelnetSender::connectedChanged);
    connect(this, &TelnetSender::hostChanged, this, &TelnetSender::connectToTelnet);
}

bool TelnetSender::connected() const
{
    return tcpSocket.state() == QTcpSocket::ConnectedState;
}

void TelnetSender::send(const QStringList &messages)
{
    for (const auto &message : messages) {
        tcpSocket.write(qPrintable(message + "\n"));
    }
}

void TelnetSender::setHost(const QString& host)
{
    if (m_host == host) {
        return;
    }

    m_host = host;
    emit hostChanged();
}

void TelnetSender::connectToTelnet()
{
    tcpSocket.abort();
    tcpSocket.connectToHost(!m_host.isEmpty() ? m_host : DEFAULT_HOST, PORT, QTcpSocket::WriteOnly);
}
