#pragma once
#include <QAbstractListModel>

struct HostData {
    QString address;
    QString name;

    HostData(const QString &address, const QString &name) : address(address), name(name) {}
};


class HostModel : public QAbstractListModel
{
    Q_OBJECT

    enum roles {
        ADDRESS = Qt::UserRole + 1,
        NAME
    };
public:
    HostModel(QObject *parent = nullptr);
    QVector<HostData> getHostDataVector();
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void addHost(const QString &address, const QString &name);
    Q_INVOKABLE void editHost(int hostIndex, const QString &address, const QString &name);
    Q_INVOKABLE void removeHost(int index);

    void init(const QVector<HostData> &data);

private:
    QVector<HostData> mHostData;

};

