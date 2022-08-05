#ifndef READEXAMPLES_H
#define READEXAMPLES_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QDebug>

class ReadExamples: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString example READ example WRITE setExample NOTIFY exampleChanged)

    QString m_example;

public:
    ReadExamples(QObject* parent = nullptr) : QObject(parent), m_example("Leer"){}

    Q_INVOKABLE void readFile(QString examplename){
        QFile file(examplename);      
        QTextStream stream(&file);

        if(!file.open(QIODevice::ReadOnly)){            
            return;
        }
        this->setExample(stream.readAll());
    }

public slots:
    QString example() const{
        return m_example;
    }

    void setExample(QString string){
        if(string == m_example) return;
        if((string.isEmpty()) || (string == "RESET")){
            qDebug()<<"String empty";
            return;
        }     
        m_example = string;
        emit exampleChanged(m_example);
    }

signals:
    void exampleChanged(QString example);
};

#endif // READEXAMPLES_H
