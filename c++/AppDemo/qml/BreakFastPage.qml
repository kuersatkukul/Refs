import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

BasePage{
    titel: "Breakfast"
    menuButtonsText: ["back","next"];

    Rectangle{
        id:frame;
        Image {
            id: breakfast;
            source: "breakfast.jpg";
            opacity: 0.7
        }
        Rectangle{
            id:content
            anchors{left:parent.left; leftMargin:75; top:parent.top; topMargin: 10;}
            Column{
                Text{
                    id:drink
                    text:"What do you drink?";
                    font.family: "Helvetica";
                    font.bold: true;
                    font.pointSize: 12;
                    color:"white";
                }
                spacing:15;
                ComboBox{
                    width: 150;
                    model: ["Juice","Tea","Coffee"];
                }
                Text{
                    id:muesli
                    text:"Do you like Müsli?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen;
                        }
                    }
                }
                Text{
                    id:brot
                    text:"Do you like bread?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen2}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen2;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen2;
                        }
                    }
                }
                Text{
                    id:sausage
                    text:"Do you like sausage?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen3}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen3;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen3;
                        }
                    }
                }
                Text{
                    id:jam
                    text:"Do you like jam?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen4}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen4;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen4;
                        }
                    }
                }
                Text{
                    id:honey
                    text:"Do you like honey?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen5}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen5;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen5;
                        }
                    }
                }
                Text{
                    id:cheese
                    text:"Do you like cheese?";
                    font.family:"Helvetica";
                    font.bold:true;
                    font.pointSize: 12;
                    color:"white";
                }
                GroupBox{
                    implicitWidth: 170;

                    RowLayout{
                        ExclusiveGroup{id:chosen6}
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("ja");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold: true;
                            }
                            checked: false;
                            exclusiveGroup: chosen6;
                        }
                        spacing:80;
                        RadioButton{
                            Text{
                                anchors{left:parent.right;leftMargin: 10;}
                                text: qsTr("nein");
                                color:"white"
                                font.family: "Helvetica";
                                font.bold:true;
                            }
                            checked: false;
                            exclusiveGroup: chosen6;
                        }
                    }
                }
            }
        }
    }
    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.pop(dailyroutinepage);break;
        case 1: mainStackView.push(freetimepage);break;
        default: console.log("error");
        }
    }
}
