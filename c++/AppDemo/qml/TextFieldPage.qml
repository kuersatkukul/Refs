import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

BasePage{
    titel: "TextFieldPage";

    menuButtonsText: ["back","home","next"];

    Rectangle{
        anchors{top:titel.bottom;left:parent.left; right:parent.right;}
        color:"lightsteelblue";
        Image {
            id: wallpaper ;
            source: "wallpaper.jpg"
        }
        Rectangle{
            id:frameinframe
            anchors{fill:parent;}
            ColumnLayout{
                spacing: 5;
                anchors{left:parent.left;leftMargin:10;top:parent.top;topMargin: 20;}
                ColorDialog{
                    id: choosecolor;
                    currentColor: choosecolor.color;
                }

                TextField{
                    Layout.preferredWidth: 520;
                    width: 500;
                    placeholderText: qsTr("Enter some text: ");
                }

                TextArea{
                    id: textfeld
                    Layout.preferredWidth: 520;
                    style: TextAreaStyle{
                        textColor: choosecolor.color;
                        backgroundColor: "lightgrey";
                    }
                    textMargin: 2;
                }
                RowLayout{
                    spacing:4;
                    Button{text:"copy"; onClicked: textfeld.copy();}
                    Button{text:"paste"; enabled: textfeld.canPaste; onClicked: textfeld.paste();}
                    Button{text:"selectAll"; onClicked: textfeld.selectAll();}
                    Button{text:"cut"; onClicked: textfeld.cut();}
                    Button{text:"undo"; enabled: textfeld.canUndo; onClicked: textfeld.undo;}
                    Button{text:"redo"; enabled: textfeld.redo; onClicked: textfeld.redo;}
                    Button{text:"color";onClicked: choosecolor.open();}
                }
                Label{
                    id:charactercount;
                    text: textfeld.length + " Zeichen im Textfeld.";
                    font.family: "Helvetica";
                    font.bold: true;
                    font.pointSize: 12;
                    color:"black";
                }
                Slider{
                    implicitWidth: 520;
                    id: zeichenslider;
                    orientation: Qt.Horizontal;
                    maximumValue: 1000000;
                    minimumValue: 0;
                    value: textfeld.length;
                }
                Rectangle{
                    id:splitframe;
                    width:520;
                    height: 300;
                    SplitView{
                        orientation: Qt.Vertical;
                        anchors{fill:parent;}
                        Repeater{
                            model:2;
                            Rectangle{
                                height: 150;
                                TextArea{
                                    id:areaindex;
                                    text: qsTr("Schreiben Sie ... ");
                                    anchors{fill:parent;}
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(slider);break;
        case 1: mainStackView.push(introPage);break;
        case 2: mainStackView.push(tabviewPage);break;
        default: console.log("error");
        }
    }
}
