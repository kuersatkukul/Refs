import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

BasePage {
    titel: "Personal"

    menuButtonsText: [ "back", "next" ]

    Rectangle {
        anchors{top:titel.bottom; left:parent.left; right:parent.right;}
        color: "grey"
        Image {
            id: personpagesky
            source: "personbg.jpg"
        }
        Rectangle{
            id:information

            anchors{left:parent.left; leftMargin:75; top:parent.top; topMargin: 10;}
            Column{
                Row{
                    Text {
                        id: firstname;
                        color: "white";
                        opacity: 0.7;
                        text: qsTr("First Name:    ");
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:10;
                    TextField{
                        placeholderText: "Put in your first name."
                        style: TextFieldStyle{
                            textColor: "red"
                            background: Rectangle{
                                radius:3;
                                implicitWidth: 200;
                                implicitHeight: 24;
                                border.color: "black"
                                border.width: 2;
                            }
                        }
                    }
                }
                spacing:20;
                Row{
                    Text{
                        id:familyname;
                        color: "white";
                        opacity: 0.7;
                        text: qsTr("Family Name: ");
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:10;
                    TextField{
                        placeholderText: "What is your familyname?";
                        style: TextFieldStyle{
                            textColor: "red";
                            background: Rectangle{
                                radius:3;
                                implicitWidth: 200;
                                implicitHeight: 24;
                                border.color:"black"
                                border.width: 2;
                            }
                        }
                    }
                }
                Row{
                    Text{
                        id:choosebirthday
                        color:"white";
                        opacity: 0.7
                        text:qsTr("Birthday:          ");
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    Label{
                        id:birthdaylabel;
                        color:"white";
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 10;
                    }
                }
                Calendar{                                       //Styling des Calendars möglich s. QML syntax style
                    weekNumbersVisible: true;
                    onSelectedDateChanged: {
                        const day=selectedDate.getDate();       //Ausgabe des Datums auf der Console
                        const month=selectedDate.getMonth();
                        const year=selectedDate.getFullYear();
                        console.log(day + "." + month + "." + year);
                    }
                    onClicked: {
                        birthdaylabel.text= "Your birthday: " + date.toLocaleDateString("dd.MM.YY");
                    }
                }
                Row{
                    Text{
                        id:gender
                        color:"white";
                        opacity: 0.7;
                        text: qsTr("Your Gender:       ");
                        font.family: "Helvetica";
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    GroupBox{
                        implicitWidth: 170;
                        RowLayout{
                            ExclusiveGroup{id:chosengender}
                            RadioButton{
                                Text{
                                    anchors{left:parent.right; leftMargin:10;}
                                    text: qsTr("woman");
                                    color:"white"
                                    opacity: 1;
                                    font.family:"Helvetica";
                                    font.bold:true;
                                }
                                checked:false;
                                exclusiveGroup: chosengender;
                            }
                            spacing:80;
                            RadioButton{
                                Text{
                                    anchors{left:parent.right; leftMargin:10;}
                                    text: qsTr("man");
                                    color:"white"
                                    opacity: 1;
                                    font.family:"Helvetica";
                                    font.bold:true;
                                }
                                checked:false;
                                exclusiveGroup: chosengender;
                            }
                        }
                    }
                }
            }
        }
    }

    onMenuButtonClicked: {
        switch ( buttonIndex ) {
        case 0: mainStackView.pop(introPage); break;
        case 1: mainStackView.push(dailyroutinepage); break;
        default: console.log("error")
        }
    }
}

