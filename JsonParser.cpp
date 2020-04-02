#include "JsonParser.h"

JsonParser::JsonParser(QObject *parent) : QObject(parent), settings(readFile())
{

}

QString JsonParser::getTargetWindowName()
{
    QJsonObject main_settings = this->settings.value(QString("main_settings")).toObject();
    QJsonValue targetWindow = main_settings.value(QString("target_window"));
    return targetWindow.toString();
}

void JsonParser::setTargetWindowName(QString windowName)
{
    qDebug() << windowName;
}

void JsonParser::writeToFile()
{
}

QJsonObject JsonParser::readFile()
{
    QFile file("config.json");
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "file error";
//        return;
//        todo: throw exception
    }
    const QByteArray ba = file.readAll();
    file.close();

    QJsonParseError err;
    QJsonDocument doc = QJsonDocument::fromJson(ba, &err);

//    qDebug() << err.errorString();
//    qDebug() << err.offset;

    QJsonObject sett2 = doc.object();
//    qDebug() << sett2.isEmpty();

    return sett2;
}
