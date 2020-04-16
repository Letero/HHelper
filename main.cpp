#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlProperty>
#include "KeystrokesSender.h"
#include "JsonParser.h"
#include "ButtonModel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<KeystrokesSender>("com.company.keystrokessender", 1, 0, "KeystrokesSender");
    qmlRegisterType<JsonParser>("com.company.jsonparser", 1, 0, "JsonParser");
    qmlRegisterSingletonType(QUrl("qrc:/Colors.qml"), "Colors", 1, 0, "Colors");
    ButtonModel model;




    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("buttonModel", &model);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
    &app, [url](QObject * obj, const QUrl & objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    engine.load(url);

//    engine.rootContext()->setContextProperty("keysender", keysender.data());

    return app.exec();
}
