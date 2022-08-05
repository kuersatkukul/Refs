import QtQuick 2.2

Rectangle {
    id: menu
    property variant buttonsText: [];
    //property variant buttonsIcons: []
    property int buttonCount: buttonsText.length; //große des arrays =length

    signal buttonClicked(int buttonIndex);

    Row{
        Repeater {
            model: buttonCount //anz buttons
            Rectangle {
                width: menu.width/buttonCount //gesamte Breite /2 da buttoncount array 2 buttons inkludiert z.b fuer personPage
                height: menu.height           //Höhe 60 siehe main.qml
                border.width: 2;
                border.color: "violet"
                color: "lightgrey"
                Text{
                    anchors.centerIn: parent;
                    text: buttonsText[index];
                }
                MouseArea {
                    anchors.fill: parent
                    onPressed: buttonClicked( index )
                }
            }
        }
    }
}

