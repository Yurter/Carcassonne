import QtQuick 2.14
import QtQuick.Window 2.14
import "../../js/Utils.js" as Utils
import "../gameplay"

Window {
    id: root

    visible: true
    width: 640
    height: 480
    title: qsTr("Carcassonne")

    property alias main_window:     root
    property alias game_field:      game_field
    property alias current_tile:    current_tile_holder.tile

    GameField {
        id: game_field
    }

    CurrentTile {
       id: current_tile_holder
    }

}