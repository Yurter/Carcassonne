import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import "../gameplay"
import "../menu"

Window {
    id: root

    visible: true
    title: qsTr("Carcassonne")
//    visibility: Window.FullScreen
    width: 640
    height: 480

    property alias main_window:     root

    // Temp solution
    property alias game_field:      game_field
    property alias current_tile:    current_tile_holder.tile
    GameField {
        id: game_field
    }
    CurrentTile {
       id: current_tile_holder
    }

    // Target solution
//    StackView {
//        id: main_stack
//        initialItem: "qrc:/qml/menu/StartWindow.qml"
//        anchors.fill: parent

//        pushEnter: Transition {}
//        pushExit:  Transition {}
//        popEnter:  Transition {}
//        popExit:   Transition {}
//    }

//    Component {
//        id: main_view

//        Row {
//            spacing: 10

//            Button {
//                text: "Push"
//                onClicked: stack.push(mainView)
//            }
//            Button {
//                text: "Pop"
//                enabled: stack.depth > 1
//                onClicked: stack.pop()
//            }
//            Text {
//                text: stack.depth
//            }
//        }
//    }
}
