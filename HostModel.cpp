#include "HostModel.h"

HostModel::HostModel(QObject *parent) : QAbstractListModel(parent)
{
}

QVector<HostData> HostModel::getHostDataVector()
{
    return mHostData;
}

int HostModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mHostData.size();
}

QVariant HostModel::data(const QModelIndex& index, int role) const
{
    auto &data = mHostData[index.row()];

    switch (role) {
    case roles::ADDRESS:
        return data.address;
    case roles::NAME:
        return data.name;
    case roles::LABEL:
        return data.name + " (" + data.address + ")";
    }

    return {};
}

QHash<int, QByteArray> HostModel::roleNames() const
{
    return {
        { roles::ADDRESS, "address" },
        { roles::NAME, "name" },
        { roles::LABEL, "label" }
    };
}

void HostModel::addHost(const QString& address, const QString& name)
{
    beginInsertRows({}, rowCount({}), rowCount({}));
    mHostData.push_back({address, name});
    endInsertRows();
}

void HostModel::editHost(int hostIndex, const QString& address, const QString& name)
{
    mHostData[hostIndex].address = address;
    mHostData[hostIndex].name = name;

    emit dataChanged(index(hostIndex, 0), index(hostIndex, 0));
}

void HostModel::removeHost(int index)
{
    beginRemoveRows({}, index, index);
    mHostData.removeAt(index);
    endRemoveRows();
}

int HostModel::findHostIndex(const QString& address)
{
    const auto it = std::find_if( mHostData.cbegin(), mHostData.cend(), [&](const auto& host){ return host.address == address; } );
    return it == mHostData.cend() ? -1 : std::distance(mHostData.cbegin(), it);
}

void HostModel::init(const QVector<HostData>& data)
{
    beginInsertRows({}, rowCount({}), rowCount({}) + data.size());
    mHostData = data;
    endInsertRows();
}
