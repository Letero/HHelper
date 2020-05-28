#include "Controller.h"
#include "TelnetSender.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlProperty>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<TelnetSender>("com.company.TelnetSender", 1, 0, "TelnetSender");
    qmlRegisterType<Controller>("com.company.controller", 1, 0, "Controller");
    qmlRegisterSingletonType(QUrl("qrc:/Colors.qml"), "Colors", 1, 0, "Colors");

    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Universal");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
    &app, [url](QObject * obj, const QUrl & objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
