#pragma once

#include <QStringListModel>

class CommandModel : public QStringListModel
{
    Q_OBJECT

public:
    explicit CommandModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void saveCommand(const QString& command);
    Q_INVOKABLE void removeCommand(const int index);

    void init(const QStringList& data);
};
