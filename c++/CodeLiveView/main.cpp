#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QFontDatabase>
#include <readexamples.h>
#include <openfile.h>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    ReadExamples* read = new ReadExamples();
    Openfile* open = new Openfile();
    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    engine.rootContext()->setContextProperty("examples",read);
    engine.rootContext()->setContextProperty("openfile",open);
    engine.load(url);
    QFontDatabase::addApplicationFont(":/fonts/fontello.ttf");

    return app.exec();
}
