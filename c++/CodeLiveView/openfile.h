#ifndef SAVEFILE_H
#define SAVEFILE_H
#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QFileDialog>

class Openfile: public QObject{
    Q_OBJECT

    Q_PROPERTY(QString openfile READ openfile WRITE setOpenfile NOTIFY openfileChanged)

    QString m_openfile;

public:
    Openfile(QObject* parent = nullptr): QObject(parent), m_openfile("Nothing to save."){}

    Q_INVOKABLE void getFile(){
        QFileDialog::getOpenFileContent("*.*",
        [this](const QString& fileName, const QByteArray& code){ //workaround to access local filesys
            if(!fileName.isEmpty()){
                this->setOpenfile(code);
            }else{
                this->setOpenfile("Nothing to save.");
            }
        });
    }

public slots:
    QString openfile() const{
        return m_openfile;
    }
    void setOpenfile(QString string){
        if(string == m_openfile){
            return;
        }
        m_openfile = string;
        emit openfileChanged(m_openfile);
    }

signals:
    void openfileChanged(QString name_of_file);
};

#endif // SAVEFILE_H
