#include "ButtonModel.h"
#include "QDebug"
#include "QJsonArray"
ButtonModel::ButtonModel(QObject *parent) : QAbstractListModel(parent)
{
}

QVector<ButtonData> ButtonModel::getButtonDataVector()
{
    return mButtonData;
}

int ButtonModel::rowCount(const QModelIndex &parent) const
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

void ButtonModel::addButton(const QString &name, const QStringList &args)
{
    qDebug() << "witam pana " << name << args;
    beginInsertRows({}, rowCount({}), rowCount({}));
    mButtonData.push_back({name, args});
    endInsertRows();
}

void ButtonModel::removeButton(int index)
{
    beginRemoveRows({}, index, index);
    mButtonData.removeAt(index);
    endRemoveRows();
}

void ButtonModel::init(const QMap<QString, QStringList> &data)
{
    for (auto key : data.keys()) {
        beginInsertRows({}, rowCount({}), rowCount({}));
        mButtonData.push_back({key, data[key]});
        endInsertRows();
    }
}
