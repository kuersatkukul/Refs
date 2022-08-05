import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

BasePage{
    titel:"FreeTime";
    menuButtonsText: ["back","home","next"];

    Rectangle{
        id:frame;
        Image {
            id: nature
            source: "nature.jpg";
            opacity: 0.8;
        }
        Rectangle{
            id:text;
            anchors{left:parent.left; leftMargin: 45;}
            Text{
                id:title;
                text: qsTr("Choose your own plan for leisure.");
                font.family: "Helvetica";
                font.bold: true;
                font.pointSize: 18;
                color:"white";
            }
        }

        ListModel{
            id:freetimelist
            ListElement{freetime:"Baseball"}
        }

        Rectangle{
            id:content;
            anchors{left:parent.left; leftMargin:60; top:parent.top; topMargin: 50;}
            ColumnLayout{
                spacing:50;
                ComboBox{
                    id:combo;
                    implicitWidth: 250;
                    editable:true;
                    model:["Football","Boating","Picknick","Hiking"];
                    onCurrentIndexChanged: {
                        freetimelist.append({freetime: combo.currentText})
                    }
                }
                TableView{
                    implicitWidth: 250;
                    implicitHeight: 400;
                    TableViewColumn{role:"freetime"; title:"Aktivität";width:200;}
                    model:freetimelist;
                }
            }
        }
    }

    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(fruhstuck);break;
        case 1: mainStackView.push(introPage);break;
        case 2: mainStackView.push(slider);break;
        default:console.log("error");
        }
    }
}
