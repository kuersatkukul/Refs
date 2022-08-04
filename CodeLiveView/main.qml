import QtQuick 2.13
import QtQuick.Controls 2.5 as Controls2_5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.13



Controls2_5.ApplicationWindow{
    id: root
    minimumHeight: 768
    minimumWidth: 1366
    visible: true

    property var dynamicReference : []
    property var count: 0
    property var started_noError: 1

    Connections{
        target: examples
        onExampleChanged:{
            code.text = examples.example
        }
    }
    Connections{
        target: openfile
        onOpenfileChanged:{
            code.text = openfile.openfile
        }
    }

    menuBar: Controls2_5.MenuBar {
        Controls2_5.Menu{
            title: "Examples"
            Controls2_5.MenuItem {
                text: "Example 1"
                onTriggered: examples.readFile(":/beispiele/bsp0.txt")
            }
            Controls2_5.MenuItem {
                text: "Example 2"
                onTriggered: examples.readFile(":/beispiele/bsp1.txt")
            }
            Controls2_5.MenuItem {
                text: "Example 3"
                onTriggered: examples.readFile(":/beispiele/bsp2.txt")
            }
            Controls2_5.MenuItem {
                text: "Example 4"
                onTriggered: examples.readFile(":/beispiele/bsp3.txt")
            }        
            Controls2_5.MenuItem {
                text: "Example 5"
                onTriggered: examples.readFile(":/beispiele/bsp4.txt")      //charts bsp, Modul funktioniert in WebAssembly nicht
            }
            Controls2_5.MenuItem {
                text: "Example 6"
                onTriggered: examples.readFile(":/beispiele/bsp5.txt")      //GraphicalEffects bsp, friert ein nach Ausführung
            }
        }
        Controls2_5.Menu{
            title: "Fileoperations"
            Controls2_5.MenuItem{
                text: "Get Filecontent"
                onTriggered: {
                    openfile.getFile()
                }
            }
        }
        Controls2_5.Menu{
            title: "Settings"
            Controls2_5.MenuItem{
                text: "Get Blank File"
                onTriggered: {
                    examples.setExample("RESET")
                    code.text = "import QtQuick 2.13\nimport QtQuick.Window 2.13\nimport QtQuick.Controls 1.4"
                }
            }
            Controls2_5.MenuItem{
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }
    }

    //Display of Linenumbers
    TextArea{
        Column{
            anchors.fill: parent
            anchors.topMargin: 5
            Repeater{
                id: repeater
                model: code.lineCount
                Text {
                    text: modelData+1
                    font{family: "Helvetica"; pixelSize: 12}
                    color: "coral"
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                }
            }
        }
        id: linenumbers
        anchors{left: parent.left; right: splitview.left}
        height: code.height
        width: codeArea.width/13
        clip: true
        style: TextAreaStyle {
            selectionColor: "steelblue"
            backgroundColor: "grey"
        }
        readOnly: true
    }

    //Display of errors
    TextArea{
        id: errormessages
        anchors{left:parent.left; bottom: parent.bottom}
        height: parent.height - codeArea.height
        width: codeArea.width +linenumbers.width - 6 // 6 ist der kleine Asbtand für die Mitter der SplitView
        font{pixelSize: 14}
        text: "No Errors."
        style: TextAreaStyle {
            textColor: "darkred"
            selectionColor: "steelblue"
            backgroundColor: "white"
        }
        readOnly: true
    }

    SplitView{
        id: splitview
        anchors{fill: parent; leftMargin: root.width*0.02}
        orientation: Qt.Horizontal

        Rectangle{
            id: codeArea
            Layout.minimumWidth: root.width*0.3
            Layout.maximumHeight: root.height*0.7

            TextArea {
                id: code
                anchors{fill:parent; rightMargin: 6}
                font.pixelSize: 12
                style: TextAreaStyle {
                    textColor: "white"
                    selectionColor: "steelblue"
                    backgroundColor: "grey"
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Tab) {
                        event.accepted = true;
                        code.insert(code.cursorPosition,"    ")
                    }
                }
                onTextChanged: {
                    displayCreation(code.text)
                }
            }
        }
        Item{
            id: liveView
            Layout.minimumWidth: root.width*0.6
            clip: true
            Text{
                id: displayingText
                font{bold: true; pixelSize: 20}
            }
        }
    }

    function displayCreation(code){
        if(dynamicReference[count-1]){
            dynamicReference[count-1].destroy()
            count-=1
        }
        try{
            dynamicReference[count] = Qt.createQmlObject(code,liveView,"DynamicQml")
        }
        catch(fehlerobjekt){
            var error_linenumber = JSON.stringify(fehlerobjekt.qmlErrors[0].lineNumber)
            var error_msg = JSON.stringify(fehlerobjekt.qmlErrors[0].message)
            errormessages.text = "Error: Line: " + error_linenumber + "\nError Message: " + error_msg
            return
        }
        errormessages.text = "No Errors"
        count +=1
    }
}
