import QtQuick 2.2;
import QtQuick.Controls 1.4;
import QtQuick.Controls.Styles 1.4;
import QtQuick.Layouts 1.2;
import QtQuick.Dialogs 1.2;


BasePage{
    titel: "Thats the Tabview";
    menuButtonsText: ["back","home"];

    Rectangle{
        anchors{fill:parent;}
        TabView{
            anchors{left:parent.left;right:parent.right;}
            Tab{
                id: nummer1;
                title: "Tab 1";
                ColumnLayout{
                    spacing:20;
                    Text{
                        text: qsTr("Tab Nr.1");
                        font.family: "Helvetica";
                        font.bold: true;
                    }
                    Slider{
                        id: slider1;
                        maximumValue: 100;
                        value: spin1.value;
                        stepSize: 0.25;
                    }
                    SpinBox{
                        id: spin1;
                        value: slider1.value;
                        maximumValue: slider1.maximumValue;
                        decimals:1;
                    }
                }
            }
        }
    }
    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(textfeldseite);break;
        case 1: mainStackView.push(introPage);break;
        }
    }
}
