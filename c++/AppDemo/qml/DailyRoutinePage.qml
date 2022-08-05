import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

BasePage{
    titel:"DailyRoutine"

    menuButtonsText: ["back", "next"]

    Rectangle{
        anchors{fill:parent}
        Image {
            id: lowenzahn;
            source: "loewenzahn.jpg";
        }
        Rectangle{
            id:spinboxen
            anchors{left:parent.left; leftMargin:75; top:parent.top; topMargin: 10;}
            Column{
                Row{
                    Text{
                        id:getuptime
                        text:"Get up:           "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                spacing:30;
                Row{
                    Text{
                        id:leavinghouse
                        text:"Leaving:          "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                Row{
                    Text{
                        id:workingtime
                        text:"Worktime:       "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                Row{
                    Text{
                        id:lunchtime
                        text:"Lunchtime:      "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                Row{
                    Text{
                        id:endofjob
                        text:"Worktime off: "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                Row{
                    Text{
                        id:dinnertime
                        text:"Dinnertime:    "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
                Row{
                    Text{
                        id:bedtime
                        text:"Bedtime:         "
                        color: "white";
                        opacity: 1;
                        font.family: "Helvetica"
                        font.bold: true;
                        font.pointSize: 12;
                    }
                    spacing:30;
                    SpinBox{
                        decimals: 2;
                        suffix: " h";
                        maximumValue: 24;
                    }
                }
            }
        }
    }

    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(personPage); break;     //alternativ auch in der Console
        case 1: mainStackView.push(fruhstuck); break;    //aktuelle Seite ausgeben!
        default: console.log("error")
        }
    }
}
