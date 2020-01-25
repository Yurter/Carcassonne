import QtQuick 2.13
import QtQuick.Window 2.13

Window {
    id: root
    property alias main_window: root
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    GameField {
        id: game_field
//        anchors.fill: parent
    }
}
