#pragma once

#include <QObject>
#include <QTcpSocket>

class TelnetSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString host WRITE setHost NOTIFY hostChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
public:
    explicit TelnetSender(QObject *parent = nullptr);

    bool connected() const;
    Q_INVOKABLE void send(const QStringList &messages);

public slots:
    void setHost(const QString &host);
    void connectToTelnet();

signals:
    void connectedChanged();
    void hostChanged();

private:
    QTcpSocket tcpSocket;
    QString m_host;
};
