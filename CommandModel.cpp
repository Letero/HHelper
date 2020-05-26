#include "CommandModel.h"

#include <QDebug>

namespace
{
    constexpr auto MAX_ELEMENTS = 100;
}

CommandModel::CommandModel(QObject *parent)
    : QStringListModel(parent)
{
}

int CommandModel::rowCount(const QModelIndex& parent) const
{
    return QStringListModel::rowCount(parent) + 1;
}

QVariant CommandModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role)
    return QStringListModel::data(index);
}

QHash<int, QByteArray> CommandModel::roleNames() const
{
    return {
        { Qt::UserRole + 1, "role" }
    };
}

void CommandModel::saveCommand(const QString& command)
{
    auto currentList = stringList();
    const auto index = currentList.indexOf(command);
    if (index >= 0)
    {
        currentList.move(index, currentList.size() - 1);
    }
    else
    {
        currentList.append(command);

        if (currentList.size() > MAX_ELEMENTS)
        {
            currentList.removeFirst();
        }
    }

    beginResetModel();
    setStringList(currentList);
    endResetModel();
}

void CommandModel::removeCommand(const int index)
{
    auto currentList = stringList();
    currentList.removeAt(index);
    beginResetModel();
    setStringList(currentList);
    endResetModel();
}

void CommandModel::init(const QStringList& data)
{
    beginResetModel();
    setStringList(data);
    endResetModel();
}
