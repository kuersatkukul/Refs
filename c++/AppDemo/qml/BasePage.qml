import QtQuick 2.2

Item {
    height: parent.height
    width: parent.width
    visible:false;
    property string titel: "default titel"
    property variant menuButtonsText: [ "back", "next" ]
    //property variant menuButtonsIcons: [ "leftarrow.png", "qml/defaultImage2.png" ]
    signal menuButtonClicked(int buttonIndex)
}

