import QtQuick 2.2

BasePage {
    titel: "Intro"
    menuButtonsText: ["back","next"];

    //Timer { interval: 1000; running: true; onTriggered: mainStackView.push(personPage) }
    //TIMER UEBERFLUSSIG

    Rectangle {
        anchors.fill: parent
        Image {
            Image {
                id: hsma
                source: "hmannheim_1.jpg"
            }
            id: weatherimage
            anchors{top:parent.top; bottom:parent.bottom}
            source: "weather.jpg";
            //scale: 0.2;
        }

        Text{
            anchors{centerIn: parent}
            text:"Herzlich Willkommen auf der Intro-Seite\nder Hochschule Mannheim."
            font.pixelSize: 20;
            font.family: "Helvetica"
            font.bold: true;
            color: "white"
        }
    }
    onMenuButtonClicked: {
        switch(buttonIndex){
        case 0: mainStackView.push(tabviewPage);break;
        case 1: mainStackView.push(personPage); break;
        default: console.log("error");
        }
    }
}

