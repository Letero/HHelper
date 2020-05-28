#include "ButtonModel.h"

ButtonModel::ButtonModel(QObject *parent) : QAbstractListModel(parent)
{
}

QVector<ButtonData> ButtonModel::getButtonDataVector()
{
    return mButtonData;
}

int ButtonModel::rowCount(const QModelIndex &parent = {}) const
{
    Q_UNUSED(parent)
    return mButtonData.size();
}

QVariant ButtonModel::data(const QModelIndex &index, int role) const
{
    auto &data = mButtonData[index.row()];

    switch (role) {
    case roles::BUTTON_NAME:
        return data.name;
    case roles::ARGUMENTS:
        return data.arguments;
    }

    return {};
}

QHash<int, QByteArray> ButtonModel::roleNames() const
{
    return {
        { roles::BUTTON_NAME, "buttonName" },
        { roles::ARGUMENTS, "buttonArgs" }
    };
}

void ButtonModel::addButton(const QString& name, const QStringList& args)
{
    beginInsertRows({}, rowCount(), rowCount());
    QStringList purifiedList(args);
    purifiedList.removeAll(QString());
    mButtonData.push_back({name, purifiedList});
    endInsertRows();
}

void ButtonModel::editButton(int buttonIndex, const QString& name, const QStringList& args)
{
    mButtonData[buttonIndex].name = name;
    mButtonData[buttonIndex].arguments = args;

    emit dataChanged(index(buttonIndex, 0), index(buttonIndex, 0));
}

void ButtonModel::removeButton(int index)
{
    beginRemoveRows({}, index, index);
    mButtonData.removeAt(index);
    endRemoveRows();
}

void ButtonModel::init(const QVector<ButtonData>& data)
{
    beginResetModel();
    mButtonData = data;
    endResetModel();
}
