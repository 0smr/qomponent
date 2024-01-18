#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    app.setOrganizationName("smr");
    app.setOrganizationDomain("smr.best");
    app.setApplicationName("example-3");

    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("example", "Main");

    return app.exec();
}
