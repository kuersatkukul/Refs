import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

BasePage{
    titel:"SliderPage"
    menuButtonsText: ["back","home","next"];

    Rectangle{
        anchors{fill:parent;}
        Image {
            id: plane
            source: "plane.jpg";
        }
        Rectangle{
            anchors{top:parent.top;}
            width: parent.width;
            height: parent.height/2.5
            color:"transparent";

            Row{
                spacing:5;
                Repeater{
                    model:2;
                    Column{
                        Label{
                            anchors{left:parent.left;leftMargin: 15;}
                            id:checkinlabel
                            text: qsTr("--");
                            font.family: "Helvetica";
                            font.bold: true;
                            font.pointSize: 12;
                            color:"white"
                        }
                        Calendar{
                            scale:0.85;
                            onClicked: {
                                if(model.index===0)
                                    checkinlabel.text="Check in: "+ date.toLocaleDateString("dd.MM.YY");
                                else checkinlabel.text="Check out: "+ date.toLocaleDateString("dd.MM.YY");
                            }
                        }
                    }
                }
            }
            Rectangle{
                id:rahmen;
                anchors{top:parent.bottom;left:parent.left;leftMargin: 15;}
                width:parent.width;
                height: parent.height;
                color: "transparent";
                Column{
                    Row{
                        spacing:15;
                        Switch{
                            checked: true;
                            onCheckedChanged: spin.enabled=slide.enabled=checked;
                        }
                        Label{
                            text:qsTr("Number of Children");
                            font.family: "Helvetica";
                            font.pointSize: 12;
                            font.bold: true;
                            color:"white";
                        }
                    }
                    spacing:10;
                    Row{
                        spacing:15;
                        SpinBox{
                            id:spin;
                            decimals: 1;
                            value:slide.value;
                            maximumValue: slide.maximumValue;
                        }
                        Slider{
                            implicitWidth: 115;
                            id:slide;
                            value:spin.value;
                            maximumValue: 5;
                            stepSize: 1;
                        }
                    }
                }
            }
        }
    }

    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(freetimepage);break;
        case 1: mainStackView.push(introPage);break;
        case 2: mainStackView.push(textfeldseite);break;
        }
    }
}
