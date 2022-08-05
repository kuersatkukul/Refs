import QtQuick 2.2
import QtQuick.Controls 1.2

ApplicationWindow {
    id: mainWindow
    width: 1080/2;
    height: 1700/2;

    //Alle pages sind BasePagen
    IntroPage { id: introPage }
    PersonPage { id: personPage }
    DailyRoutinePage{id: dailyroutinepage}
    BreakFastPage{id: fruhstuck}
    FreeTimePage{id: freetimepage}
    SliderPage{id: slider}
    TextFieldPage{id: textfeldseite}
    TabViewPage{id:tabviewPage;}
    Rectangle {         //Titelrect
        id: titel
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 60
        color:"lightgrey"

        Text {
            anchors.centerIn: parent
            text: mainStackView.currentItem.titel
            font.pointSize: 24
            font.family: "Helvetica"
        }
    }

    StackView {        //Stackview
        id: mainStackView
        anchors{ top: titel.bottom; left: parent.left; right: parent.right; bottom: menubar.top }
        initialItem: introPage // Qt.resolvedUrl("IntroPage.qml")
        //FIRST ITEM TO BE SHOWN WHEN STACKVIEW IS CREATED
    }

    MyMenu {
        id: menubar
        anchors{ left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 60;
        buttonsText: mainStackView.currentItem.menuButtonsText
        //buttonsIcons: mainStackView.currentItem.menuButtonsText
        onButtonClicked: mainStackView.currentItem.menuButtonClicked( buttonIndex )
    }

    Component.onCompleted: show()
}


