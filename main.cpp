#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "logincontroller.h"
#include "reliabilitycontroller.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setOrganizationName("SecureCorp");
    app.setOrganizationDomain("securecorp.com");
    app.setApplicationName("SecurityPortal");

    QQmlApplicationEngine engine;

    LoginController loginController;
    engine.rootContext()->setContextProperty("loginController", &loginController);

    ReliabilityController reliabilityController;
    engine.rootContext()->setContextProperty("reliabilityController", &reliabilityController);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
