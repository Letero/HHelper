#pragma once
#include <QAbstractListModel>
#include <QDebug>
struct ButtonData {
    QString name;
    QStringList arguments;

    ButtonData(const QString &n, const QStringList &args) : name(n), arguments(args) {}
};


class ButtonModel : public QAbstractListModel
{
    Q_OBJECT
    enum roles {
        BUTTON_NAME = Qt::UserRole + 1,
        ARGUMENTS
    };

public:
    ButtonModel(QObject *parent = nullptr);
    QVector<ButtonData> getButtonDataVector();
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void addButton(const QString &name, const QStringList &args);
    Q_INVOKABLE void removeButton(int index);

    Q_INVOKABLE void init(const QVariantMap &args);


    void init1(const QMap<QString, QStringList> &data)
    {

        for (auto key : data.keys()) {
            qDebug() << data[key];


            beginInsertRows({}, rowCount({}), rowCount({}));
            mButtonData.push_back({key, data[key]});
            endInsertRows();
        }
    }

private:
    QVector<ButtonData> mButtonData;

};

